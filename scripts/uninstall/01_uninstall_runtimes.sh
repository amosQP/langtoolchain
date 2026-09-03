#!/usr/bin/env sh
# Uninstalls each asdf-managed language runtime listed in .tool-versions.
# Ensures asdf/shims are on PATH itself, same reasoning as every other
# phase script — main.sh runs each phase as its own process.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
readonly REPO_ROOT
# Same TOOL_VERSIONS_FILE convention as the install side, though the
# uninstaller's main.sh doesn't currently set it — this just keeps the two
# sides consistent and lets someone wire up a selective uninstall later.
#
# Absent that, prefer $HOME/.tool-versions (where 06_set_globals.sh actually
# wrote versions for a GLOBAL-scope install, via `asdf set -u`) over this
# repo's own default .tool-versions. Falling back to the repo default here
# unconditionally meant a version chosen interactively at install time
# (e.g. the TASK-28 override flow) was never what got checked/uninstalled
# below — this phase would compare against the wrong version string and
# report a still-installed runtime as "already absent".
if [ -n "${TOOL_VERSIONS_FILE:-}" ]; then
  readonly CONFIG_FILE="$TOOL_VERSIONS_FILE"
elif [ -f "$HOME/.tool-versions" ]; then
  readonly CONFIG_FILE="$HOME/.tool-versions"
else
  readonly CONFIG_FILE="$REPO_ROOT/.tool-versions"
fi

step "Phase 1: Uninstalling language runtimes"

# uninstall_from_config_file <file>: asdf-uninstalls every plugin/version
# pair listed in <file>. Shared by the global config below and, per
# directory, by the LOCAL-scope pins loop further down (TASK-83) — same
# logic either way, just a different .tool-versions-style file to read.
#######################################
# asdf-uninstall every plugin/version pair listed in a config file.
# Globals:
#   None
# Arguments:
#   $1: path to a .tool-versions-style config file
# Outputs:
#   Writes progress lines ("Uninstalling ...", "Already absent: ...") to
#   STDOUT (via log()).
# Returns:
#   None
#######################################
uninstall_from_config_file() {
  # fd 3, not stdin — see scripts/install/02_install_plugins.sh for why.
  # POSIX sh has no process substitution, so each_tool's output goes to a
  # temp file first.
  local each_tool_tmp
  each_tool_tmp="$(mktemp)"
  each_tool "$1" > "$each_tool_tmp"
  while read -r plugin version <&3; do
    # Check before uninstalling so re-running this script on a partially
    # torn-down machine doesn't error out on versions already gone.
    if asdf list "$plugin" "$version" >/dev/null 2>&1; then
      log "Uninstalling $plugin $version ..."
      # `|| true`: don't let one stubborn uninstall abort the whole loop.
      if run asdf uninstall "$plugin" "$version"; then
        lt_report removed "$plugin $version (asdf)"
      fi
    else
      log "Already absent: $plugin $version"
    fi
  done 3< "$each_tool_tmp"
  rm -f "$each_tool_tmp"
}

if [ -f "$CONFIG_FILE" ]; then
  uninstall_from_config_file "$CONFIG_FILE"
else
  # Nothing to read means nothing we know how to remove from here — not an
  # error; the LOCAL-scope pins below might still have something to do.
  log "No .tool-versions found — assuming global runtimes are already gone."
fi

# LOCAL-scope pins (TASK-83): every directory 06_set_globals.sh ever pinned
# versions into locally, recorded in LT_LOCAL_PINS_FILE_NAME under
# $ASDF_DATA_DIR. A version only ever pinned inside a project directory
# never appears in $CONFIG_FILE above, so without this it would silently
# survive uninstall. A directory that's since been deleted, or had its
# .tool-versions removed by hand, is skipped rather than treated as an error.
readonly LOCAL_PINS_FILE="$ASDF_DATA_DIR/$LT_LOCAL_PINS_FILE_NAME"
if [ -f "$LOCAL_PINS_FILE" ]; then
  # fd 4 (not 3, not stdin): uninstall_from_config_file's own inner loop
  # already owns fd 3 for its each_tool read, and this loop calls that
  # function from inside its own body — fd 4 keeps the two from colliding.
  while read -r pin_dir <&4; do
    [ -n "$pin_dir" ] || continue
    if [ -f "$pin_dir/.tool-versions" ]; then
      log "Uninstalling local pins from: $pin_dir"
      uninstall_from_config_file "$pin_dir/.tool-versions"
    fi
  done 4< "$LOCAL_PINS_FILE"
fi
