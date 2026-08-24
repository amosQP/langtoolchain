#!/usr/bin/env bash
# Ensures Homebrew and asdf itself are present. Both of these steps were
# missing entirely in the original version of this tool — a fresh Mac with
# neither pre-installed would fail immediately with "brew: command not
# found" or "asdf: command not found". Self-contained: does not assume any
# other phase ran first.
set -euo pipefail

# Resolve this script's own directory so `. lib.sh` works no matter where
# the caller's shell happened to be `cd`'d.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 1: Ensuring Homebrew and asdf are installed"

# Hard requirement: everything downstream (Homebrew formulas, asdf itself)
# assumes macOS. Fail loudly and immediately rather than limping through
# the rest of the script on an unsupported OS.
[[ "$(uname)" == "Darwin" ]] || die "This installer only supports macOS."

# Homebrew might already be on PATH from a normal shell — or might have
# been installed by a previous run of THIS script but not yet be visible
# in this fresh process (see ensure_brew_on_path in lib.sh for why).
ensure_brew_on_path

if command -v brew >/dev/null 2>&1; then
  log "Homebrew found: $(command -v brew)"
else
  log "Homebrew not found — installing (this will ask for your password once, via sudo)..."
  # The official installer. NONINTERACTIVE=1 skips its "Press RETURN to
  # continue" confirmation prompt; it still runs `sudo` internally to
  # create /opt/homebrew (or /usr/local on Intel) the first time, which
  # will prompt for the account password in the terminal as normal — that
  # part can't be automated away, and shouldn't be.
  run env NONINTERACTIVE=1 bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # The installer just placed `brew` at a fixed location but didn't add it
  # to this process's PATH — do that now so the rest of THIS run can use it.
  ensure_brew_on_path
  command -v brew >/dev/null 2>&1 || die \
    "Homebrew install finished but 'brew' still isn't on PATH. Open a new terminal and re-run this installer."
  log "Homebrew installed: $(command -v brew)"
fi

if command -v asdf >/dev/null 2>&1; then
  # Already installed (e.g. re-running the installer) — nothing to do.
  # `|| true` covers the (unlikely) case asdf exists but `version` errors.
  log "asdf already installed: $(asdf version 2>/dev/null || true)"
else
  # `run` respects --dry-run: prints "+ brew install asdf" instead of
  # actually installing under DRY_RUN=true.
  run brew install asdf
fi
