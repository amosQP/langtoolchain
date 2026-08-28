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

step "Phase 1: Ensuring Homebrew and asdf are installed"

# Hard requirement: everything downstream (Homebrew formulas, asdf itself)
# assumes macOS. Fail loudly and immediately rather than limping through
# the rest of the script on an unsupported OS.
[ "$(uname)" = "Darwin" ] || die "This installer only supports macOS."

# Homebrew might already be on PATH from a normal shell — or might have
# been installed by a previous run of THIS script but not yet be visible
# in this fresh process (see ensure_brew_on_path in lib.sh for why).
ensure_brew_on_path

if command -v brew >/dev/null 2>&1; then
  log "Homebrew found: $(command -v brew)"
else
  log "Homebrew not found — installing (this will ask for your password once, via sudo)..."
  if [ "$DRY_RUN" = "true" ]; then
    # `run` alone can't gate this: `$(curl ...)` is a command substitution,
    # which bash expands *before* `run` ever sees the result — piping it
    # straight into `run env ... bash -c "$(curl ...)"` would still fetch
    # the real installer (and, if printed, dump its entire multi-KB source
    # into the dry-run output) even though nothing gets executed. Gate the
    # fetch itself, not just the execution.
    log "  + curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | NONINTERACTIVE=1 bash"
  else
    # The official installer. NONINTERACTIVE=1 skips its "Press RETURN to
    # continue" confirmation prompt; it still runs `sudo` internally to
    # create /opt/homebrew (or /usr/local on Intel) the first time, which
    # will prompt for the account password in the terminal as normal — that
    # part can't be automated away, and shouldn't be.
    #
    # retry (TASK-88): the whole thing is wrapped in a single-quoted `sh -c`
    # string, not run directly — retry() re-runs its argument list as-is on
    # each attempt, and `$(curl ...)` inside an unquoted command would only
    # ever be fetched ONCE (when this line is first parsed), before retry
    # even gets a chance to loop. Deferring it into `sh -c '...'` makes the
    # curl fetch itself happen fresh on every retry attempt.
    retry 3 5 sh -c 'env NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  fi
  # The installer just placed `brew` at a fixed location but didn't add it
  # to this process's PATH — do that now so the rest of THIS run can use it.
  ensure_brew_on_path
  if [ "$DRY_RUN" != "true" ]; then
    command -v brew >/dev/null 2>&1 || die \
      "Homebrew install finished but 'brew' still isn't on PATH. Open a new terminal and re-run this installer."
    log "Homebrew installed: $(command -v brew)"
  fi
fi

if command -v asdf >/dev/null 2>&1; then
  # Already installed (e.g. re-running the installer) — nothing to do.
  # `|| true` covers the (unlikely) case asdf exists but `version` errors.
  log "asdf already installed: $(asdf version 2>/dev/null || true)"
else
  # `run` respects --dry-run: prints "+ brew install asdf" instead of
  # actually installing under DRY_RUN=true. retry (TASK-88): a formula
  # download failing on a flaky connection shouldn't need a full manual
  # re-run.
  retry 3 5 run brew install asdf
fi
