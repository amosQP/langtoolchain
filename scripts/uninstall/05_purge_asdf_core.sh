#!/usr/bin/env bash
# Removes asdf itself and its data directory. Only ever touches the user's
# *global* ~/.tool-versions — never this repo's own .tool-versions, which is
# a tracked project file, not machine state.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 5: Removing asdf core"

if brew list asdf &>/dev/null; then
  log "Uninstalling asdf (Homebrew) ..."
  run brew uninstall asdf || true
fi

if [[ -d "$HOME/.asdf" ]]; then
  log "Removing $HOME/.asdf ..."
  run rm -rf "$HOME/.asdf"
fi

if [[ -f "$HOME/.tool-versions" ]]; then
  log "Removing $HOME/.tool-versions ..."
  run rm -f "$HOME/.tool-versions"
fi
