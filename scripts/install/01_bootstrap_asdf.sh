#!/usr/bin/env sh
# Ensures Homebrew and asdf itself are present. Both of these steps were
# missing entirely in the original version of this tool — a fresh Mac with
# neither pre-installed would fail immediately with "brew: command not
# found" or "asdf: command not found". Self-contained: does not assume any
# other phase ran first.
set -eu

# Resolve this script's own directory so `. lib.sh` works no matter where
# the caller's shell happened to be `cd`'d. $0 works because every caller
# always invokes this script by path (POSIX sh has no BASH_SOURCE).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

# Pinned to a specific Homebrew/install commit rather than the floating
# "HEAD" ref, with its content hash recorded here (TASK-117.2) - the same
# pin-and-verify idea as install.sh's own self-clone (TASK-117.1), applied
# to a plain file fetch instead of a git ref. Homebrew doesn't publish an
# official checksum/signature for this script (confirmed 2026-09: no
# .sha256/.asc alongside it on GitHub) - this SHA-256 is one this project
# computed itself at pin time and trusts going forward. It defends against
# the script changing silently between "this was reviewed" and "this
# runs" (a compromised CDN/registry serving different bytes for the same
# URL), not against Homebrew's own source being malicious to begin with -
# that's outside what any locally-computed checksum can prove (see
# docs/download-integrity-techniques.md #1's integrity-vs-authenticity
# distinction).
#
# Bump both together when intentionally picking up a newer Homebrew
# installer:
#   curl -fsSL https://raw.githubusercontent.com/Homebrew/install/<new-sha>/install.sh | shasum -a 256
HOMEBREW_INSTALL_COMMIT="c8188c1d48d77234a458b944d1d1b750f015a1c4"
HOMEBREW_INSTALL_URL="https://raw.githubusercontent.com/Homebrew/install/$HOMEBREW_INSTALL_COMMIT/install.sh"
HOMEBREW_INSTALL_SHA256="12479a24be3f5307eecac7cde670fad7118640f031229e964f544b1367b52a41"

step "Phase 1: Ensuring Homebrew and asdf are installed"

# Hard requirement: everything downstream (Homebrew formulas, asdf itself)
# assumes macOS. Fail loudly and immediately rather than limping through
# the rest of the script on an unsupported OS.
[ "$(uname)" = "Darwin" ] || die "This installer only supports macOS."

# Homebrew might already be on PATH from a normal shell — or might have
# been installed by a previous run of THIS script but not yet be visible
# in this fresh process (see ensure_brew_on_path in lib.sh for why).
ensure_brew_on_path

# fetch_verified_homebrew_installer <dest-file> (TASK-117.2): downloads the
# pinned Homebrew installer to <dest-file> and checks its SHA-256 before
# returning success. Fails (non-zero, <dest-file> left in whatever partial
# state curl left it) if either the fetch or the checksum comparison fails,
# so the caller never executes content that didn't match what was pinned.
fetch_verified_homebrew_installer() {
  local dest="$1" actual_sha256
  curl -fsSL -o "$dest" "$HOMEBREW_INSTALL_URL" || return 1
  actual_sha256="$(shasum -a 256 "$dest" | awk '{print $1}')"
  if [ "$actual_sha256" != "$HOMEBREW_INSTALL_SHA256" ]; then
    log "  Homebrew installer checksum mismatch: expected $HOMEBREW_INSTALL_SHA256, got $actual_sha256 — refusing to run it."
    return 1
  fi
}

# run_homebrew_installer (TASK-117.2): fetches into a fresh temp file (so a
# partial/failed prior attempt is never reused) with checksum verification,
# then hands the now-verified on-disk file to bash — a genuine two-stage
# fetch-then-execute, replacing the old single `bash -c "$(curl ...)"`
# fetch-and-exec-in-one-breath pattern. NONINTERACTIVE=1 skips the "Press
# RETURN to continue" prompt; the installer still shells out to `sudo`
# internally the first time (creates /opt/homebrew or /usr/local), which
# prompts for the account password in the terminal as normal — that part
# can't be automated away, and shouldn't be.
run_homebrew_installer() {
  local dest status
  dest="$(mktemp)"
  if fetch_verified_homebrew_installer "$dest"; then
    NONINTERACTIVE=1 bash "$dest"
    status=$?
  else
    status=1
  fi
  rm -f "$dest"
  return "$status"
}

# install_homebrew_if_missing (m-8): extracted so this script's own
# top-level flow reads as two named steps (see the two calls at the bottom
# of this file) instead of two inline if/else blocks back to back.
install_homebrew_if_missing() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew found: $(command -v brew)"
    return
  fi
  log "Homebrew not found — installing (this will ask for your password once, via sudo)..."
  if [ "$DRY_RUN" = "true" ]; then
    # `run` alone can't gate this: the real branch's fetch happens inside a
    # function call, not a command substitution `run` could inspect from
    # the outside — gate the whole fetch+verify+execute at this if/else
    # instead, same as before.
    log "  + fetch $HOMEBREW_INSTALL_URL, verify sha256 == $HOMEBREW_INSTALL_SHA256, then NONINTERACTIVE=1 bash <verified file>"
  else
    # retry (TASK-88): `run_homebrew_installer` (defined above the two
    # top-level calls at the bottom of this file) does its own fresh
    # curl+verify inside the function body every time it's called — unlike
    # the old `sh -c '$(curl ...)'` trick this used to need, a plain shell
    # function re-runs its own commands on every call, so no extra
    # subshell wrapping is needed to make retry's repeated calls actually
    # re-fetch instead of replaying a value captured once at parse time.
    retry 3 5 run_homebrew_installer
  fi
  # The installer just placed `brew` at a fixed location but didn't add it
  # to this process's PATH — do that now so the rest of THIS run can use it.
  ensure_brew_on_path
  if [ "$DRY_RUN" != "true" ]; then
    command -v brew >/dev/null 2>&1 || die \
      "Homebrew install finished but 'brew' still isn't on PATH. Open a new terminal and re-run this installer."
    log "Homebrew installed: $(command -v brew)"
    lt_report installed "Homebrew ($(command -v brew))"
  fi
}

# install_asdf_if_missing (m-8): same reasoning as install_homebrew_if_missing above.
install_asdf_if_missing() {
  if command -v asdf >/dev/null 2>&1; then
    # Already installed (e.g. re-running the installer) — nothing to do.
    # `|| true` covers the (unlikely) case asdf exists but `version` errors.
    log "asdf already installed: $(asdf version 2>/dev/null || true)"
    return
  fi
  # `run` respects --dry-run: prints "+ brew install asdf" instead of
  # actually installing under DRY_RUN=true. retry (TASK-88): a formula
  # download failing on a flaky connection shouldn't need a full manual
  # re-run.
  retry 3 5 run brew install asdf
  lt_report installed "asdf (Homebrew)"
}

install_homebrew_if_missing
install_asdf_if_missing
