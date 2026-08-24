#!/usr/bin/env bash
# No `set -e` — a test runner should evaluate every assertion, not stop at
# the first failure.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 6: Validating teardown"

if [[ "${DRY_RUN:-false}" == "true" ]]; then
  log "(dry-run: nothing was actually removed, skipping validation)"
  exit 0
fi

OK=true

if command -v asdf &>/dev/null; then
  log "  FAIL: 'asdf' is still resolvable in PATH."
  OK=false
else
  log "  OK:   asdf removed from PATH."
fi

case ":$PATH:" in
  *".asdf/shims"*) log "  FAIL: .asdf/shims is still in this session's PATH."; OK=false ;;
  *) log "  OK:   PATH has no asdf shims." ;;
esac

if [[ -n "${JAVA_HOME:-}" && "$JAVA_HOME" == *".asdf"* ]]; then
  log "  FAIL: \$JAVA_HOME still points into .asdf."
  OK=false
else
  log "  OK:   JAVA_HOME not pointing at asdf."
fi

log ""
if $OK; then
  log "검증 통과: 정리가 완료되었습니다."
  exit 0
else
  log "위 FAIL 항목은 현재 셸 세션에 남은 캐시입니다. 'exec \$SHELL' (또는 새 터미널) 후 다시 확인하세요."
  exit 1
fi
