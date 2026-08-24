#!/usr/bin/env bash
# Binds each selected language to a version and regenerates shims.
# Self-sufficient: ensures asdf is on PATH itself.
#
# Scope (global vs local) comes from the "# scope: ..." line 00_select.sh
# may have written as the first line of the selection file — see
# read_scope() in lib.sh. A config file with no such line (e.g. this
# repo's own .tool-versions, used when running this phase standalone)
# defaults to global, matching the tool's original behavior.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 6: Setting versions"

SCOPE_INFO="$(read_scope "$CONFIG_FILE")"

case "$SCOPE_INFO" in
  local:*)
    TARGET_DIR="${SCOPE_INFO#local:}"
    log "Pinning versions locally in: $TARGET_DIR"
    # fd 3, not stdin — see 02_install_plugins.sh for why.
    while read -r plugin version <&3; do
      log "Setting local $plugin -> $version"
      # Plain `asdf set` (no -u) writes/updates <TARGET_DIR>/.tool-versions
      # instead of the global ~/.tool-versions — subshell so the `cd` here
      # never affects this script's own cwd.
      ( cd "$TARGET_DIR" && run asdf set "$plugin" "$version" )
    done 3< <(each_tool "$CONFIG_FILE")
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
    done 3< <(each_tool "$CONFIG_FILE")
    ;;
esac

# Regenerates every shim under $ASDF_DATA_DIR/shims (node, python, ...).
# Scope-independent: shims are generic dispatchers that resolve the active
# version at invocation time, not something baked in at reshim time.
run asdf reshim
