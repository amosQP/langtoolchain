# 경로/환경변수 하드코딩 회귀 패턴 (TASK-125.1)

이 문서는 이 저장소에서 실제로 발생했던 "경로/환경변수 하드코딩" 클래스의
회귀 버그 5건(TASK-57, 61, 65, 70, 78)의 diff를 근거로, 신규 스크립트에서
같은 클래스의 버그가 재발하는지 자동 감지하기 위한 대상 패턴을 정리한다.
TASK-125.2(감지 방식 결정)와 TASK-125.3(구현)의 입력 자료로 쓴다.

## 근거 커밋

| 태스크 | 커밋 | 파일 | 하드코딩 지점 | 올바른 대안 |
|---|---|---|---|---|
| TASK-57 | 39108c5 | scripts/install/07_validate.sh | `*".asdf/shims/"*` 문자열 리터럴로 shim 경로 판정 | `"$ASDF_DATA_DIR/shims/"*` — `ensure_asdf_on_path()`가 export한 `$ASDF_DATA_DIR` 사용 |
| TASK-61 | 7422cfd | scripts/lib.sh (`ensure_build_flags`) | `/opt/homebrew/opt/sqlite/bin`을 arch 분기 없이 고정 | `"$(lt_homebrew_prefix)/opt/sqlite/bin"` |
| TASK-65 | c73f1ae | scripts/uninstall/06_validate_teardown.sh | PATH/JAVA_HOME 검사에서 `.asdf` 리터럴 매칭 | `ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"` 폴백 후 그 변수로 매칭 |
| TASK-70 | cf438f9 | scripts/uninstall/05_purge_asdf_core.sh | 삭제 대상이 항상 `$LT_ASDF_DATA_DIR_DEFAULT` | `TARGET_ASDF_DATA_DIR="${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}"` |
| TASK-78 | 77d913f | scripts/uninstall/04_remove_system_deps.sh, 05_purge_asdf_core.sh | `brew`가 이미 PATH에 있다고 암묵 가정 (`ensure_brew_on_path` 호출 누락) | 사용 전 반드시 `ensure_brew_on_path` 호출 |

TASK-78은 문자열 하드코딩이 아니라 "환경 준비 헬퍼 호출 누락"이라는 인접
클래스지만, 근본 원인이 같다(안전한 공용 헬퍼를 거치지 않고 환경이
특정 상태라고 가정)는 점에서 함께 정리한다. 이 항목은 정적 grep으로
자동 감지하기 어려워(호출 "누락"은 부재를 증명해야 함) TASK-125.2/.3의
1차 구현 범위에서는 제외하고, TASK-125.4 전수 스캔 시 수동 체크리스트
항목으로만 남긴다.

## 감지 대상 패턴 (자동화 가능한 것)

| # | 패턴 | 의미 | grep 예시 (참고용, 최종 정규식은 TASK-125.3에서 확정) | 올바른 대안 |
|---|---|---|---|---|
| 1 | `.asdf` 리터럴이 따옴표 안 문자열/case 패턴에 등장 | ASDF_DATA_DIR 대신 기본 경로를 고정 | `grep -nE '["'"'"']\.?/?\.asdf' scripts/**/*.sh` (단, `lib.sh` 안의 `LT_ASDF_DATA_DIR_DEFAULT` 정의 자체와 주석은 오탐이므로 제외 필요) | `$ASDF_DATA_DIR` (또는 `${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}`) 사용 |
| 2 | `/opt/homebrew` 리터럴 | Apple Silicon Homebrew prefix를 고정, Intel(`/usr/local`) 미고려 | `grep -n '/opt/homebrew' scripts/**/*.sh` (단, `lib.sh`의 `lt_homebrew_prefix()` 함수 정의 자체는 제외) | `$(lt_homebrew_prefix)` |
| 3 | `$HOME/.asdf` 또는 `~/.asdf` 직접 참조 | 위 1과 유사하지만 `$HOME` 결합형 | `grep -nE '\$HOME/\.asdf|~/\.asdf' scripts/**/*.sh` | `$ASDF_DATA_DIR` 계열 |
| 4 | `LT_ASDF_DATA_DIR_DEFAULT`를 조건/삭제 대상으로 직접 사용(오버라이드 변수 없이) | TASK-70과 동일 패턴 재발 | 코드 검토 필요(순수 grep으로 자동 구분 어려움 — "직접 사용 vs `${ASDF_DATA_DIR:-...}` 폴백의 우변으로 사용"을 구분해야 함) | `${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}` 패턴으로 감싸기 |

패턴 1, 2, 3은 grep 기반으로 기계적으로 잡을 수 있는 후보이고, 이미
정당한 예외(정의부/주석)가 존재하므로 **완전 자동 오탐 제거는 불가능하고
allowlist 또는 목록 대조 방식이 필요**하다 — 이 트레이드오프가
TASK-125.2 감지 방식 결정의 핵심 판단 근거다. 패턴 4는 순수 문자열
매칭으로는 오탐이 너무 많아(모든 `LT_ASDF_DATA_DIR_DEFAULT` 참조가
문제인 게 아니라 "삭제/판정에 오버라이드 없이 직접 쓰는" 경우만 문제) 자동
검출 대상에서 제외하고 리뷰 체크리스트로만 남긴다.

## lib.sh의 정답 헬퍼

- `ensure_asdf_on_path()` — `ASDF_DATA_DIR` export, `${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}` 패턴의 정답 구현
- `lt_homebrew_prefix()` — arch 분기 포함 Homebrew prefix 계산의 정답 구현
- `ensure_brew_on_path()` — TASK-78 클래스(환경 준비 헬퍼 호출 누락)의 정답 헬퍼
