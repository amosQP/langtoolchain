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

DRY_RUN=false
AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --yes) AUTO_YES=true ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done
# Exported so every phase script below (each its own `sh` process) can
# see it via lib.sh.
export DRY_RUN

echo "langtoolchain uninstaller"
echo "asdf, 모든 asdf 런타임, 관련 Homebrew 패키지, 이 도구가 추가한 셸 설정을 제거합니다."

if ! $AUTO_YES; then
  printf "계속할까요? [y/N] > "
  # Read straight from the terminal device, not this script's own stdin —
  # matters when this file itself was piped in via `curl | bash`.
  read -r reply < /dev/tty || reply=""
  case "$reply" in
    y|Y|yes|YES) ;;
    *) echo "취소되었습니다."; exit 1 ;;
  esac
fi

# Each phase runs as its own `sh` process, independent of the others —
# same reasoning as scripts/install/main.sh.
for phase in \
  01_uninstall_runtimes.sh \
  02_remove_plugins.sh \
  03_clean_env_vars.sh \
  04_remove_system_deps.sh \
  05_purge_asdf_core.sh
do
  sh "$SCRIPT_DIR/$phase"
done

echo ""
# Temporarily allow the validation phase to fail without killing this
# script outright — its exit code is meaningful (0 = clean, 1 = stale
# session state) and we want to report on it ourselves below rather than
# letting `set -e` abort mid-way.
set +e
sh "$SCRIPT_DIR/06_validate_teardown.sh"
VALIDATION_EXIT_CODE=$?
set -e

if [ "$VALIDATION_EXIT_CODE" -eq 0 ]; then
  echo "제거가 완료되었습니다. 'exec \$SHELL'로 새 세션을 여세요."
else
  echo "제거는 끝났지만 위 경고를 확인하세요."
  exit "$VALIDATION_EXIT_CODE"
fi
