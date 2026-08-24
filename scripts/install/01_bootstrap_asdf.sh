#!/usr/bin/env bash
# Ensures Homebrew and asdf itself are present. This step was missing
# entirely in the original version of this tool — a fresh Mac with no asdf
# pre-installed would fail on the very next phase with "asdf: command not
# found". Self-contained: does not assume any other phase ran first.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 1: Ensuring asdf is installed"

[[ "$(uname)" == "Darwin" ]] || die "This installer only supports macOS."

command -v brew >/dev/null 2>&1 || die \
  "Homebrew is required but not found. Install it first: https://brew.sh"
log "Homebrew found: $(command -v brew)"

if command -v asdf >/dev/null 2>&1; then
  log "asdf already installed: $(asdf version 2>/dev/null || true)"
else
  run brew install asdf
fi
