#!/usr/bin/env sh
# No `set -e` — a test runner should evaluate every assertion, not stop at
# the first failure.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 6: Validating teardown"

# Under --dry-run nothing was actually removed, so every check below would
# report FAIL against a machine that's still fully intact — skip instead.
if [ "${DRY_RUN:-false}" = "true" ]; then
  log "(dry-run: nothing was actually removed, skipping validation)"
  exit 0
fi

OK=true

# This script deliberately does NOT call ensure_asdf_on_path() — a teardown
# check has no reason to put asdf back on PATH. That means it can't rely on
# lib.sh to have exported ASDF_DATA_DIR, so (same fix as 07_validate.sh /
# TASK-57) fall back to lib.sh's own default constant here instead of a
# literal, to avoid false-FAILing a custom ASDF_DATA_DIR.
ASDF_DATA_DIR="${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}"

if command -v asdf >/dev/null 2>&1; then
  log "  FAIL: 'asdf' is still resolvable in PATH."
  OK=false
else
  log "  OK:   asdf removed from PATH."
fi

# Colons bracket the check so "$ASDF_DATA_DIR/shims" can't false-positive-match
# a differently named path that merely contains that substring.
case ":$PATH:" in
  *":$ASDF_DATA_DIR/shims:"*) log "  FAIL: \$ASDF_DATA_DIR/shims is still in this session's PATH."; OK=false ;;
  *) log "  OK:   PATH has no asdf shims." ;;
esac

# POSIX [ ] has no glob-pattern matching, so this is a case statement
# instead of [[ -n ... && ... == pat* ]]. An unset/empty JAVA_HOME simply
# won't match the (always non-empty) "$ASDF_DATA_DIR"* pattern, so it
# falls through to the OK branch same as before.
case "${JAVA_HOME:-}" in
  "$ASDF_DATA_DIR"*)
    log "  FAIL: \$JAVA_HOME still points into \$ASDF_DATA_DIR."
    OK=false
    ;;
  *)
    log "  OK:   JAVA_HOME not pointing at asdf."
    ;;
esac

log ""
if $OK; then
  log "검증 통과: 정리가 완료되었습니다."
  exit 0
else
  # A still-open shell keeps the OLD PATH/JAVA_HOME cached even after the
  # underlying files are gone — this isn't a real failure, just stale state
  # in the current process's environment.
  log "위 FAIL 항목은 현재 셸 세션에 남은 캐시입니다. 'exec \$SHELL' (또는 새 터미널) 후 다시 확인하세요."
  exit 1
fi
