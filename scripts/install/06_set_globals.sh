#!/usr/bin/env sh
# Binds each selected language to a version and regenerates shims.
# Self-sufficient: ensures asdf is on PATH itself.
#
# Scope (global vs local) comes from the "# scope: ..." line 00_select.sh
# may have written as the first line of the selection file — see
# read_scope() in lib.sh. A config file with no such line (e.g. this
# repo's own .tool-versions, used when running this phase standalone)
# defaults to global, matching the tool's original behavior.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
readonly REPO_ROOT
readonly CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 6: Setting versions"

SCOPE_INFO="$(read_scope "$CONFIG_FILE")"
readonly SCOPE_INFO

# POSIX sh has no process substitution, so each_tool's output goes to a
# temp file first — both branches below read from the same one.
EACH_TOOL_TMP="$(mktemp)"
readonly EACH_TOOL_TMP
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"

case "$SCOPE_INFO" in
  local:*)
    readonly TARGET_DIR="${SCOPE_INFO#local:}"
    log "Pinning versions locally in: $TARGET_DIR"
    # fd 3, not stdin — see 02_install_plugins.sh for why.
    while read -r plugin version <&3; do
      log "Setting local $plugin -> $version"
      # Plain `asdf set` (no -u) writes/updates <TARGET_DIR>/.tool-versions
      # instead of the global ~/.tool-versions — subshell so the `cd` here
      # never affects this script's own cwd.
      ( cd "$TARGET_DIR" && run asdf set "$plugin" "$version" )
      lt_report modified \
        "$plugin -> $version (local, $TARGET_DIR/.tool-versions)"
    done 3< "$EACH_TOOL_TMP"
    # Record this directory (TASK-83) so uninstall/01_uninstall_runtimes.sh
    # can find it later and asdf-uninstall whatever got pinned here — the
    # global ~/.tool-versions never mentions a local-only version, so
    # without this record uninstall has no way to know it exists. Skipped
    # under DRY_RUN: the `run asdf set` calls above didn't really pin
    # anything, so recording the directory here would be a false record.
    # `grep -qxF` dedupes: installing into the same directory twice must
    # not grow this file forever.
    if [ "$DRY_RUN" != "true" ]; then
      readonly LOCAL_PINS_FILE="$ASDF_DATA_DIR/$LT_LOCAL_PINS_FILE_NAME"
      grep -qxF "$TARGET_DIR" "$LOCAL_PINS_FILE" 2>/dev/null \
        || printf '%s\n' "$TARGET_DIR" >> "$LOCAL_PINS_FILE"
    fi
    ;;
  *)
    # fd 3, not stdin — see 02_install_plugins.sh for why.
    while read -r plugin version <&3; do
      log "Setting global $plugin -> $version"
      # `-u` = user/global scope: writes/updates the plugin's line in
      # $HOME/.tool-versions (NOT this repo's own .tool-versions), so the
      # chosen version applies everywhere on the machine, not just this
      # repo directory.
      run asdf set -u "$plugin" "$version"
      lt_report modified "$plugin -> $version (global, ~/.tool-versions)"
    done 3< "$EACH_TOOL_TMP"
    ;;
esac
rm -f "$EACH_TOOL_TMP"

# Regenerates every shim under $ASDF_DATA_DIR/shims (node, python, ...).
# Scope-independent: shims are generic dispatchers that resolve the active
# version at invocation time, not something baked in at reshim time.
run asdf reshim
