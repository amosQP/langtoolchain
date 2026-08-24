#!/usr/bin/env bash
# The slow part: compiles/installs each selected language runtime via asdf.
# Ensures asdf/shims + build flags itself instead of trusting phase 04's rc
# file edits to already be sourced into this process.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path
ensure_build_flags

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 5: Installing language runtimes (this can take a while)"

# fd 3, not stdin — see 02_install_plugins.sh for why.
while read -r plugin version <&3; do
  log "Installing $plugin $version ..."
  run asdf install "$plugin" "$version"
done 3< <(each_tool "$CONFIG_FILE")
