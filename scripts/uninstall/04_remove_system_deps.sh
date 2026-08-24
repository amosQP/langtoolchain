#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 4: Removing system build dependencies (Homebrew)"

for pkg in openssl readline sqlite3 xz zlib tcl-tk; do
  if brew list "$pkg" &>/dev/null; then
    log "Uninstalling $pkg ..."
    run brew uninstall "$pkg" || log "  Skipped $pkg (likely required by another package)."
  fi
done
