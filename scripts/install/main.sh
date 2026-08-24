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
SELECT_OPTS=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --all) SELECT_OPTS="$SELECT_OPTS --all" ;;
    --yes) SELECT_OPTS="$SELECT_OPTS --yes" ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
export DRY_RUN

echo "langtoolchain installer"

if SELECTION_FILE="$(bash "$SCRIPT_DIR/00_select.sh" $SELECT_OPTS)"; then
  export TOOL_VERSIONS_FILE="$SELECTION_FILE"
else
  echo "설치가 취소되었습니다."
  exit 1
fi

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

rm -f "$SELECTION_FILE"

echo ""
echo "완료되었습니다. 'source ~/.zshrc' (또는 새 터미널)을 실행해 PATH를 반영하세요."
