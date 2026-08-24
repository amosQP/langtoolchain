#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 4: Removing system build dependencies (Homebrew)"

for pkg in openssl readline sqlite3 xz zlib tcl-tk; do
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
