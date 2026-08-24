#!/usr/bin/env bash
# Ensures Homebrew and asdf itself are present. This step was missing
# entirely in the original version of this tool — a fresh Mac with no asdf
# pre-installed would fail on the very next phase with "asdf: command not
# found". Self-contained: does not assume any other phase ran first.
set -euo pipefail

# Resolve this script's own directory so `. lib.sh` works no matter where
# the caller's shell happened to be `cd`'d.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 1: Ensuring asdf is installed"

# Hard requirement: everything downstream (Homebrew formulas, asdf itself)
# assumes macOS. Fail loudly and immediately rather than limping through
# the rest of the script on an unsupported OS.
[[ "$(uname)" == "Darwin" ]] || die "This installer only supports macOS."

# `command -v brew` is the portable way to check "is this on PATH" without
# actually running it. die() prints to stderr and exits 1 if it's missing.
command -v brew >/dev/null 2>&1 || die \
  "Homebrew is required but not found. Install it first: https://brew.sh"
log "Homebrew found: $(command -v brew)"

if command -v asdf >/dev/null 2>&1; then
  # Already installed (e.g. re-running the installer) — nothing to do.
  # `|| true` covers the (unlikely) case asdf exists but `version` errors.
  log "asdf already installed: $(asdf version 2>/dev/null || true)"
else
  # `run` respects --dry-run: prints "+ brew install asdf" instead of
  # actually installing under DRY_RUN=true.
  run brew install asdf
fi
