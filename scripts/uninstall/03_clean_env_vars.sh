#!/usr/bin/env bash
# Strips every line this tool's install phase (04_configure_shell_env.sh)
# may have added, from whichever rc files exist. Checks both zsh and bash
# rc files regardless of the current $SHELL, since the install may have
# happened under a different shell than the one running uninstall.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 3: Cleaning shell environment variables"

for rc in "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc"; do
  [[ -f "$rc" ]] || continue
  log "Cleaning $rc ..."
  if [[ "$DRY_RUN" == "true" ]]; then
    log "  + remove asdf/build-flag lines (sed -i.bak) from $rc"
    continue
  fi
  sed -i '.bak' \
    -e '/set-java-home\.\(zsh\|bash\)/d' \
    -e '/ASDF_DATA_DIR/d' \
    -e '/opt\/sqlite\/bin/d' \
    -e '/LDFLAGS.*openssl/d' \
    -e '/CPPFLAGS.*openssl/d' \
    -e '/PKG_CONFIG_PATH.*openssl/d' \
    -e '/libexec\/asdf\.sh/d' \
    "$rc"
  log "  Backup preserved at ${rc}.bak"
done
