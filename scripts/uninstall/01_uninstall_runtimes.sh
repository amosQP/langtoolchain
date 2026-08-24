#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
# Same TOOL_VERSIONS_FILE convention as the install side, though the
# uninstaller's main.sh doesn't currently set it — this just keeps the two
# sides consistent and lets someone wire up a selective uninstall later.
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"

step "Phase 1: Uninstalling language runtimes"

if [[ ! -f "$CONFIG_FILE" ]]; then
  # Nothing to read means nothing we know how to remove — not an error.
  log "No .tool-versions found — assuming runtimes are already gone."
  exit 0
fi

# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why.
while read -r plugin version <&3; do
  # Check before uninstalling so re-running this script on a partially
  # torn-down machine doesn't error out on versions already gone.
  if asdf list "$plugin" "$version" >/dev/null 2>&1; then
    log "Uninstalling $plugin $version ..."
    # `|| true`: don't let one stubborn uninstall abort the whole loop.
    run asdf uninstall "$plugin" "$version" || true
  else
    log "Already absent: $plugin $version"
  fi
done 3< <(each_tool "$CONFIG_FILE")
