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

if [[ -d "$LT_ASDF_DATA_DIR_DEFAULT" ]]; then
  # This is where EVERYTHING asdf-managed actually lives: downloads,
  # installs, plugins, and shims all sit under here. Removing it deletes
  # every compiled runtime this tool ever installed.
  log "Removing $LT_ASDF_DATA_DIR_DEFAULT ..."
  run rm -rf "$LT_ASDF_DATA_DIR_DEFAULT"
fi

if [[ -f "$HOME/.tool-versions" ]]; then
  # Deliberately $HOME/.tool-versions (the machine-wide default asdf falls
  # back to) — NOT $REPO_ROOT/.tool-versions, which is a file tracked in
  # this git repo and not something an uninstaller should ever delete.
  log "Removing $HOME/.tool-versions ..."
  run rm -f "$HOME/.tool-versions"
fi
