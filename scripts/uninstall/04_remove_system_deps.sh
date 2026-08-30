#!/usr/bin/env sh
# Removes the Homebrew build-dependency formulas (LT_BUILD_DEPS in lib.sh)
# this tool installed for Python's C extensions — mirrors the install side's
# 03_install_system_deps.sh.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
# Same reasoning as every brew-touching install phase (see lib.sh): this
# runs as its own process, so `brew` moments-old on PATH in some other
# phase's process isn't guaranteed to be on THIS one's PATH too.
ensure_brew_on_path

step "Phase 4: Removing system build dependencies (Homebrew)"

for pkg in $LT_BUILD_DEPS; do
  # Only try to uninstall what's actually installed — brew would otherwise
  # just error on an already-absent formula. `&>` is a bash-only shorthand
  # for redirecting both stdout and stderr — POSIX only has `>x 2>&1`.
  if brew list "$pkg" >/dev/null 2>&1; then
    log "Uninstalling $pkg ..."
    # Homebrew refuses to uninstall a formula something else still depends
    # on; treat that refusal as informational, not fatal, since these
    # formulas are commonly shared with other tools on the machine.
    if run brew uninstall "$pkg"; then
      lt_report removed "Homebrew package: $pkg"
    else
      log "  Skipped $pkg (likely required by another package)."
    fi
  fi
done
