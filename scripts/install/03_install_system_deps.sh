#!/usr/bin/env bash
# System-level Homebrew packages needed to compile Python's C extensions
# (ssl, sqlite, zlib, ...). Installed unconditionally since they're small
# and brew install is idempotent regardless of which languages were
# selected in phase 00.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 3: Installing system build dependencies (Homebrew)"

# One brew call for all six — brew skips anything already installed, so
# this is safe (and fast) to re-run.
run brew install openssl readline sqlite3 xz zlib tcl-tk
