#!/usr/bin/env sh
# Orchestrator: runs each install phase in its own process, in order.
# Each phase is independently correct and independently runnable — this
# script exists only for the convenience of running all of them at once.
#
# Flags:
#   --dry-run     print what would happen, change nothing
#   --all         skip the language picker, install everything in .tool-versions
#   --yes         skip the final "install these?" confirmation
#   --local[=DIR] pin versions to DIR (default: current directory) instead
#                 of globally; also skips the interactive global/local prompt
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

# Exclusive lock (TASK-84): must be first, before anything else runs, so the
# whole pipeline below (including 00_select.sh) is protected — not just the
# phases. Shared with uninstall/main.sh, so install can't race an uninstall
# either. Combined with the SELECTION_FILE cleanup into one trap below once
# SELECTION_FILE is known, since a second `trap ... EXIT` would silently
# replace this one rather than add to it.
acquire_lock
trap 'release_lock' EXIT
# INT/TERM (TASK-90): a separate trap slot from EXIT above, so registering
# this doesn't replace the lock-release trap — both fire on Ctrl-C (INT
# trap runs handle_interrupt's `exit 130`, which then triggers the EXIT
# trap for the actual cleanup).
trap 'handle_interrupt' INT TERM

DRY_RUN=false
# Flags meant for 00_select.sh get collected here, one per line, instead of
# a bash array (POSIX sh has none) — a --local=<dir with spaces> still
# survives the trip intact, since the split below only breaks on newline.
SELECT_OPTS=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --all) SELECT_OPTS="${SELECT_OPTS}--all
" ;;
    --yes) SELECT_OPTS="${SELECT_OPTS}--yes
" ;;
    --local) SELECT_OPTS="${SELECT_OPTS}--local
" ;;
    --local=*) SELECT_OPTS="${SELECT_OPTS}${arg}
" ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
# Exported so every phase script (each launched as its own `sh` process
# below) can see it via lib.sh's `DRY_RUN="${DRY_RUN:-false}"`.
export DRY_RUN

echo "langtoolchain installer"

# TASK-91: fail fast on insufficient disk space, before asking the user
# anything below — better than getting through the whole language picker
# only to have a compile die from ENOSPC partway through phase 5. Skipped
# under DRY_RUN, matching every other DRY_RUN-gated check in this codebase:
# this is a precondition for a REAL run, not something a preview needs.
if [ "$DRY_RUN" != "true" ]; then
  ensure_disk_space 5
fi

# 00_select.sh writes prompts to /dev/tty and its actual result (a file
# path) to stdout, so command substitution here captures just that path.
# If the user backs out (answers "n" to everything, or declines the final
# confirmation), it exits non-zero and prints nothing — the `if` catches
# that instead of letting `set -e` kill this script with a confusing error.
# IFS=newline turns $SELECT_OPTS back into separate positional parameters
# (splitting only on the newlines added above, not on spaces inside a
# --local=<dir with spaces> value); an empty $SELECT_OPTS splits into zero
# parameters, matching the "no extra flags" case.
IFS="
"
# shellcheck disable=SC2086
set -- $SELECT_OPTS
unset IFS
if SELECTION_FILE="$(sh "$SCRIPT_DIR/00_select.sh" "$@")"; then
  # Every later phase reads $TOOL_VERSIONS_FILE instead of the repo's own
  # .tool-versions, so they only touch what the user actually picked.
  export TOOL_VERSIONS_FILE="$SELECTION_FILE"
  # Clean up this temp file on ANY exit from here on, not just the success
  # path at the bottom of this script — otherwise a phase failing partway
  # through (network blip during 05_install_runtimes.sh, etc.) leaves it
  # behind, since `set -eu` kills the script before it ever reaches the
  # unconditional `rm -f` that used to be the only cleanup. Replaces (not
  # adds to) the lock-only trap set above — folds release_lock in too, since
  # a script has only one EXIT trap at a time.
  trap 'rm -f "$SELECTION_FILE"; release_lock' EXIT
else
  echo "설치가 취소되었습니다."
  exit 1
fi

# Each phase runs as its OWN `sh` process (not sourced) — this is what
# makes them independent: none of them can accidentally rely on a variable
# or exported PATH change that only happened in a sibling phase's process.
for phase in \
  01_bootstrap_asdf.sh \
  02_install_plugins.sh \
  03_install_system_deps.sh \
  04_configure_shell_env.sh \
  05_install_runtimes.sh \
  06_set_globals.sh \
  07_validate.sh
do
  sh "$SCRIPT_DIR/$phase"
done

echo ""
echo "완료되었습니다. 'source ~/.zshrc' (또는 새 터미널)을 실행해 PATH를 반영하세요."
