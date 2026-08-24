#!/usr/bin/env bash
# Orchestrator: runs each teardown phase in its own process, in order.
#
# Flags:
#   --dry-run   print what would happen, change nothing
#   --yes       skip the "are you sure?" confirmation
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=false
AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --yes) AUTO_YES=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
export DRY_RUN

echo "langtoolchain uninstaller"
echo "asdf, 모든 asdf 런타임, 관련 Homebrew 패키지, 이 도구가 추가한 셸 설정을 제거합니다."

if ! $AUTO_YES; then
  printf "계속할까요? [y/N] > "
  read -r reply < /dev/tty || reply=""
  case "$reply" in
    y|Y|yes|YES) ;;
    *) echo "취소되었습니다."; exit 1 ;;
  esac
fi

for phase in \
  01_uninstall_runtimes.sh \
  02_remove_plugins.sh \
  03_clean_env_vars.sh \
  04_remove_system_deps.sh \
  05_purge_asdf_core.sh
do
  bash "$SCRIPT_DIR/$phase"
done

echo ""
set +e
bash "$SCRIPT_DIR/06_validate_teardown.sh"
VALIDATION_EXIT_CODE=$?
set -e

if [[ $VALIDATION_EXIT_CODE -eq 0 ]]; then
  echo "제거가 완료되었습니다. 'exec \$SHELL'로 새 세션을 여세요."
else
  echo "제거는 끝났지만 위 경고를 확인하세요."
  exit "$VALIDATION_EXIT_CODE"
fi
