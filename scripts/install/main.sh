#!/usr/bin/env bash
# Orchestrator: runs each install phase in its own process, in order.
# Each phase is independently correct and independently runnable — this
# script exists only for the convenience of running all of them at once.
#
# Flags:
#   --dry-run   print what would happen, change nothing
#   --all       skip the language picker, install everything in .tool-versions
#   --yes       skip the final "install these?" confirmation
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=false
# Flags meant for 00_select.sh get collected here as a plain string (not an
# array) and passed through unquoted below — simple and safe since these
# are always single, space-free flag words.
SELECT_OPTS=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --all) SELECT_OPTS="$SELECT_OPTS --all" ;;
    --yes) SELECT_OPTS="$SELECT_OPTS --yes" ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
# Exported so every phase script (each launched as its own `bash` process
# below) can see it via lib.sh's `DRY_RUN="${DRY_RUN:-false}"`.
export DRY_RUN

echo "langtoolchain installer"

# 00_select.sh writes prompts to /dev/tty and its actual result (a file
# path) to stdout, so command substitution here captures just that path.
# If the user backs out (answers "n" to everything, or declines the final
# confirmation), it exits non-zero and prints nothing — the `if` catches
# that instead of letting `set -e` kill this script with a confusing error.
if SELECTION_FILE="$(bash "$SCRIPT_DIR/00_select.sh" $SELECT_OPTS)"; then
  # Every later phase reads $TOOL_VERSIONS_FILE instead of the repo's own
  # .tool-versions, so they only touch what the user actually picked.
  export TOOL_VERSIONS_FILE="$SELECTION_FILE"
else
  echo "설치가 취소되었습니다."
  exit 1
fi

# Each phase runs as its OWN `bash` process (not sourced) — this is what
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
  bash "$SCRIPT_DIR/$phase"
done

# The selection file was only ever a temporary hand-off between 00_select.sh
# and the phases above — clean it up now that they're done with it.
rm -f "$SELECTION_FILE"

echo ""
echo "완료되었습니다. 'source ~/.zshrc' (또는 새 터미널)을 실행해 PATH를 반영하세요."
