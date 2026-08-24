#!/usr/bin/env bash
# The slow part: compiles/installs each selected language runtime via asdf.
# Ensures asdf/shims + build flags itself instead of trusting phase 04's rc
# file edits to already be sourced into this process.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
# `asdf install` needs `asdf` itself on PATH ...
ensure_asdf_on_path
# ... and Python specifically needs these to find OpenSSL/SQLite/zlib
# while compiling — phase 04 wrote them into the rc file for *future*
# shells, but this process needs them right now.
ensure_build_flags

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 5: Installing language runtimes (this can take a while)"

# fd 3, not stdin — see 02_install_plugins.sh for why.
while read -r plugin version <&3; do
  log "Installing $plugin $version ..."
  # This is the actual compile/download step — by far the slowest part of
  # the whole installer. `run` still respects --dry-run.
  run asdf install "$plugin" "$version"
done 3< <(each_tool "$CONFIG_FILE")
