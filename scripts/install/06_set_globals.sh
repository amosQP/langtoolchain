#!/usr/bin/env bash
# Binds each selected language to its global asdf version and regenerates
# shims. Self-sufficient: ensures asdf is on PATH itself.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 6: Setting global versions"

# fd 3, not stdin — see 02_install_plugins.sh for why.
while read -r plugin version <&3; do
  log "Setting global $plugin -> $version"
  # `-u` = user/global scope: writes/updates the plugin's line in
  # $HOME/.tool-versions (NOT this repo's own .tool-versions), so the
  # chosen version applies everywhere on the machine, not just this repo
  # directory.
  run asdf set -u "$plugin" "$version"
done 3< <(each_tool "$CONFIG_FILE")

# Regenerates every shim under $ASDF_DATA_DIR/shims (node, python, ...) so
# they point at the versions just installed/selected.
run asdf reshim
