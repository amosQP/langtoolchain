#!/usr/bin/env sh
# Orchestrator: runs each teardown phase in its own process, in order.
#
# Flags:
#   --dry-run   print what would happen, change nothing
#   --yes       skip the "are you sure?" confirmation
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

# Exclusive lock (TASK-84), shared with install/main.sh, so this can't race
# another uninstall or an install. Must be first, before the confirmation
# prompt even, so nothing below ever runs concurrently with another instance.
acquire_lock
trap 'release_lock' EXIT
# INT/TERM (TASK-90): separate trap slot from EXIT above — see
# install/main.sh for why registering this doesn't clobber the lock-release
# trap.
trap 'handle_interrupt' INT TERM

DRY_RUN=false
AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --yes) AUTO_YES=true ;;
    *) printf '%s\n' "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
# Exported so every phase script below (each its own `sh` process) can
# see it via lib.sh.
export DRY_RUN

printf '%s\n' "langtoolchain uninstaller"
printf '%s\n' "This will remove asdf, every asdf-managed runtime, the related Homebrew packages, and the shell config this tool added."

# Probe for a controlling terminal first - same technique as
# install/00_select.sh's own INTERACTIVE check (`true < /dev/tty` either
# succeeds, or fails with its own stderr suppressed here). Without this, the
# `read` below would leak a raw "/dev/tty: Device not configured" shell
# error straight to the user the moment there's no tty at all (CI, or this
# script piped through something with no terminal) - found during a UX pass
# (m-6/TASK-97.1). No tty and no --yes: proceed anyway, the same way
# 00_select.sh auto-falls-back to --all under those conditions, rather than
# leaving the user staring at a prompt that can never be answered.
INTERACTIVE=true
{ true < /dev/tty; } 2>/dev/null || INTERACTIVE=false

if ! $AUTO_YES && $INTERACTIVE; then
  printf "Continue? [y/N] > "
  # Read straight from the terminal device, not this script's own stdin —
  # matters when this file itself was piped in via `curl | bash`.
  read -r reply < /dev/tty || reply=""
  case "$reply" in
    y|Y|yes|YES) ;;
    *) printf '%s\n' "Cancelled."; exit 1 ;;
  esac
fi

# Each phase runs as its own `sh` process, independent of the others —
# same reasoning as scripts/install/main.sh. run_phase (not a plain
# `sh "$SCRIPT_DIR/$phase"` call) so the INT/TERM trap above can actually
# interrupt a phase mid-flight — see run_phase's own comment in lib.sh.
for phase in \
  01_uninstall_runtimes.sh \
  02_remove_plugins.sh \
  03_clean_env_vars.sh \
  04_remove_system_deps.sh \
  05_purge_asdf_core.sh
do
  run_phase "$SCRIPT_DIR/$phase"
done

printf '\n'
# Temporarily allow the validation phase to fail without killing this
# script outright — its exit code is meaningful (0 = clean, 1 = stale
# session state) and we want to report on it ourselves below rather than
# letting `set -e` abort mid-way.
set +e
sh "$SCRIPT_DIR/06_validate_teardown.sh"
VALIDATION_EXIT_CODE=$?
set -e

# DRY_RUN-aware (found during a UX pass, m-6/TASK-94.3): under --dry-run,
# 06_validate_teardown.sh above exits 0 via its own dry-run skip path (there
# was nothing to validate, not "validated clean") - without this branch a
# preview-only run would print the same "complete" message as a real one.
if [ "$DRY_RUN" = "true" ]; then
  printf '%s\n' "Dry run complete. Nothing was actually removed or changed."
elif [ "$VALIDATION_EXIT_CODE" -eq 0 ]; then
  printf '%s\n' "Removal complete. Run 'exec \$SHELL' to start a fresh session."
else
  printf '%s\n' "Removal finished, but check the warnings above."
  exit "$VALIDATION_EXIT_CODE"
fi
