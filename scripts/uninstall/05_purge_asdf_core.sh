#!/usr/bin/env sh
# Removes asdf itself and its data directory. Only ever touches the user's
# *global* ~/.tool-versions — never this repo's own .tool-versions, which is
# a tracked project file, not machine state.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 5: Removing asdf core"

if brew list asdf >/dev/null 2>&1; then
  log "Uninstalling asdf (Homebrew) ..."
  run brew uninstall asdf || true
fi

# Respect a live ASDF_DATA_DIR override (same "${VAR:-default}" pattern
# ensure_asdf_on_path() uses) instead of always assuming the default — a
# user who installed with a custom ASDF_DATA_DIR would otherwise have their
# real data directory silently left behind (TASK-70).
TARGET_ASDF_DATA_DIR="${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}"

if [ -d "$TARGET_ASDF_DATA_DIR" ]; then
  # This is where EVERYTHING asdf-managed actually lives: downloads,
  # installs, plugins, and shims all sit under here. Removing it deletes
  # every compiled runtime this tool ever installed.
  log "Removing $TARGET_ASDF_DATA_DIR ..."
  run rm -rf "$TARGET_ASDF_DATA_DIR"
fi

if [ -f "$HOME/.tool-versions" ]; then
  # Deliberately $HOME/.tool-versions (the machine-wide default asdf falls
  # back to) — NOT $REPO_ROOT/.tool-versions, which is a file tracked in
  # this git repo and not something an uninstaller should ever delete.
  log "Removing $HOME/.tool-versions ..."
  run rm -f "$HOME/.tool-versions"
fi
