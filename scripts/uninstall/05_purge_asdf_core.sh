#!/usr/bin/env sh
# Removes asdf itself and its data directory. Only ever touches the user's
# *global* ~/.tool-versions — never this repo's own .tool-versions, which is
# a tracked project file, not machine state.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
# Same reasoning as every brew-touching install phase (see lib.sh): this
# runs as its own process, so `brew` moments-old on PATH in some other
# phase's process isn't guaranteed to be on THIS one's PATH too.
ensure_brew_on_path

step "Phase 5: Removing asdf core"

if brew list asdf >/dev/null 2>&1; then
  log "Uninstalling asdf (Homebrew) ..."
  if run brew uninstall asdf; then
    lt_report removed "asdf (Homebrew)"
  fi
fi

# Respect a live ASDF_DATA_DIR override (same fallback ensure_asdf_on_path()
# uses, via lt_asdf_data_dir()) instead of always assuming the default — a
# user who installed with a custom ASDF_DATA_DIR would otherwise have their
# real data directory silently left behind (TASK-70).
TARGET_ASDF_DATA_DIR="$(lt_asdf_data_dir)"

if [ -d "$TARGET_ASDF_DATA_DIR" ]; then
  # This is where EVERYTHING asdf-managed actually lives: downloads,
  # installs, plugins, and shims all sit under here. Removing it deletes
  # every compiled runtime this tool ever installed.
  log "Removing $TARGET_ASDF_DATA_DIR ..."
  run rm -rf "$TARGET_ASDF_DATA_DIR"
  lt_report removed "$TARGET_ASDF_DATA_DIR (entire asdf data dir: installs, plugins, shims)"
fi

if [ -f "$HOME/.tool-versions" ]; then
  # Deliberately $HOME/.tool-versions (the machine-wide default asdf falls
  # back to) — NOT $REPO_ROOT/.tool-versions, which is a file tracked in
  # this git repo and not something an uninstaller should ever delete.
  log "Removing $HOME/.tool-versions ..."
  run rm -f "$HOME/.tool-versions"
  lt_report removed "$HOME/.tool-versions"
fi
