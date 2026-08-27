#!/usr/bin/env bash
# Removes the Homebrew build-dependency formulas (LT_BUILD_DEPS in lib.sh)
# this tool installed for Python's C extensions — mirrors the install side's
# 03_install_system_deps.sh.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 4: Removing system build dependencies (Homebrew)"

for pkg in $LT_BUILD_DEPS; do
  # Only try to uninstall what's actually installed — brew would otherwise
  # just error on an already-absent formula.
  if brew list "$pkg" &>/dev/null; then
    log "Uninstalling $pkg ..."
    # Homebrew refuses to uninstall a formula something else still depends
    # on; treat that refusal as informational, not fatal, since these
    # formulas are commonly shared with other tools on the machine.
    run brew uninstall "$pkg" || log "  Skipped $pkg (likely required by another package)."
  fi
done
