#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

step "Phase 2: Removing asdf plugins"

# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why.
while read -r plugin <&3; do
  [[ -n "$plugin" ]] || continue
  log "Removing plugin: $plugin"
  run asdf plugin remove "$plugin" || true
done 3< <(asdf plugin list 2>/dev/null)
