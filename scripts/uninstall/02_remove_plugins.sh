#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

step "Phase 2: Removing asdf plugins"

# Removes EVERY installed plugin, not just the ones this repo's
# .tool-versions lists — asdf is being uninstalled entirely in phase 5, so
# leftover plugins from other tools would just become orphaned directories
# under ~/.asdf/plugins with no asdf left to manage them.
#
# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why.
while read -r plugin <&3; do
  [[ -n "$plugin" ]] || continue   # skip a stray blank line, if any
  log "Removing plugin: $plugin"
  run asdf plugin remove "$plugin" || true
done 3< <(asdf plugin list 2>/dev/null)
