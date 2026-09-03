---
id: decision-1
title: '경로/환경변수 하드코딩 감지 방식: grep 기반 lint 스크립트 채택'
date: '2026-09-03 01:17'
status: accepted
---
## Context

TASK-125.1(scripts/lint/hardcoded-paths-patterns.md)에서 TASK-57/61/65/70/78
diff를 근거로, "경로/환경변수를 커스텀 오버라이드 무시하고 하드코딩"하는
회귀 패턴이 신규 스크립트에서 재발하지 않도록 자동 감지 장치가 필요하다는
결론을 냈다. 감지 방식으로 3개 옵션을 조사했다.

| 옵션 | 실현 가능성 | CI 연결 난이도 | 유지보수 비용 | 비고 |
|---|---|---|---|---|
| 1) shellcheck 커스텀 룰 | 사실상 불가 | - | - | 이 개발 머신 shellcheck 0.11.0 `--help`에 custom/plugin/rule 확장 옵션이 전혀 없음. shellcheck은 고정된 내장 룰셋만 제공하며(Haskell 구현, 플러그인 API 없음) 프로젝트별 임의 문자열 금지 룰을 추가하는 공식 메커니즘이 없다. 우회하려면 shellcheck을 포크하거나 출력을 후처리해야 하는데, 이는 "커스텀 룰"이 아니라 사실상 옵션 2를 shellcheck 뒤에 덧붙이는 것과 같다. |
| 2) grep 기반 lint 스크립트 | 높음 | 낮음 | 낮음 | scripts/lint/ 아래 독립 POSIX sh 스크립트로 구현 가능. 로컬에서 단독 실행 가능하고, `.github/workflows/e2e-verify.yml`에 저비용(ubuntu-latest, 실제 Homebrew/macOS 불필요) 신규 job으로 추가해 비싼 실기기 job들보다 먼저/병렬로 빠르게 실패시킬 수 있다. |
| 3) shellspec 테스트로 소스를 grep | 중간 | 이 저장소는 현재 CI에 shellspec을 전혀 연결하고 있지 않음(`.github/workflows/`에 워크플로가 e2e-verify.yml 하나뿐이고 이는 실기기 설치/제거 검증 전용) — shellspec 자체를 CI에 처음 연결하는 작업이 선행돼야 하므로 옵션 2보다 CI 연결 비용이 크다 | 중간 | shellspec은 "스크립트를 실행하고 동작/출력을 검증"하는 용도로 이미 쓰이고 있고(spec/), "소스 코드 텍스트를 정적으로 스캔"하는 이 작업의 성격과는 다르다. shellspec DSL로 감싸도 결국 내부는 grep이라 이중 레이어가 됨. |

세 옵션 모두 정당한 예외(예: `lib.sh`의 `lt_homebrew_prefix()`/`ensure_asdf_on_path()` 정의부 자체, 주석)를 완전 자동으로 걸러낼 수 없어 allowlist가 필요하다는 점은 공통이다.

## Decision

**옵션 2: grep 기반 독립 lint 스크립트**를 채택한다.

- 위치: `scripts/lint/check-hardcoded-paths.sh` (POSIX sh, 기존 저장소 스타일과 동일)
- TASK-125.1에서 정리한 감지 대상 패턴(1~3번: `.asdf` 리터럴, `/opt/homebrew` 리터럴, `$HOME/.asdf` 직접 참조)을 grep으로 검사하고, 정당한 예외는 스크립트 내 allowlist(파일:줄 또는 파일 단위)로 관리한다.
- 4번 패턴(`LT_ASDF_DATA_DIR_DEFAULT` 직접 사용)과 TASK-78류(헬퍼 호출 누락)는 자동화 오탐률이 너무 높아 1차 구현 범위에서 제외하고, TASK-125.4 전수 스캔 시 수동 체크리스트로만 남긴다.
- CI 연결: `.github/workflows/e2e-verify.yml`에 `ubuntu-latest` 기반의 저비용 신규 job(`lint-hardcoded-paths` 등)을 추가해, 비싼 실기기 `full-cycle` job들과 별도로 빠르게 실패시킨다. 기존 `paths:` 필터(scripts/** 등)를 그대로 적용받는다.
- 이유: shellcheck은 커스텀 룰 메커니즘이 없어 옵션 1은 실행 불가. 옵션 3은 이 저장소가 shellspec을 아직 CI에 전혀 연결하지 않은 상태라 "정적 텍스트 스캔"을 위해 처음부터 CI-shellspec 연결까지 새로 만들어야 하는 추가 비용이 있고, 성격상으로도(동작 검증 vs 정적 스캔) 옵션 2가 더 맞는 도구다.

## Consequences

- `scripts/lint/` 디렉터리가 새로 생기고, TASK-125.3에서 `check-hardcoded-paths.sh`를 실제로 구현한다.
- CI에 shellspec을 연결하는 별도 작업(옵션 3에서 필요했을 것)은 이번 범위에서 하지 않는다 — 필요해지면 별도 태스크로 논의.
- allowlist 관리가 필요해지므로, 새 예외가 생길 때마다(예: lib.sh에 새 헬퍼 정의 추가) lint 스크립트의 allowlist도 함께 갱신해야 한다는 점을 TASK-125.3 구현 시 스크립트 상단 주석에 명시한다.

