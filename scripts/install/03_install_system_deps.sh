#!/usr/bin/env sh
# System-level Homebrew packages needed to compile Python's C extensions
# (ssl, sqlite, zlib, ...). Installed unconditionally since they're small
# and brew install is idempotent regardless of which languages were
# selected in phase 00.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
# Phase 1 may have installed Homebrew moments ago in a different process —
# make sure `brew` is resolvable in THIS one too.
ensure_brew_on_path

step "Phase 3: Installing system build dependencies (Homebrew)"

# One brew call for all six — brew skips anything already installed, so
# this is safe (and fast) to re-run. retry (TASK-88): worth a couple of
# attempts before giving up on a network blip.
retry 3 5 run brew install $LT_BUILD_DEPS
# Reports the whole batch, not just the subset actually newly-installed
# this run (unlike 02_install_plugins.sh) - brew install is idempotent
# per-package but this is one combined call, and splitting it just to get
# a precise per-package "already had this one" distinction isn't worth the
# extra `brew list` round-trips for an audit log entry.
lt_report installed "Homebrew packages: $LT_BUILD_DEPS"
