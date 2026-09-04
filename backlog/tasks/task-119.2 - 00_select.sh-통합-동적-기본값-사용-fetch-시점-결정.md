---
id: TASK-119.2
title: '00_select.sh 통합: 동적 기본값 사용 + fetch 시점 결정'
status: Done
assignee: []
created_date: '2026-08-30 11:41'
updated_date: '2026-09-03 01:20'
labels: []
dependencies:
  - TASK-119.1
  - TASK-118.3
parent_task_id: TASK-119
type: task
ordinal: 146000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
119.1에서 추가한 헬퍼를 scripts/install/00_select.sh의 ask_version()(282-298)/lt_offer_language()(368-393)에 연결해 정적 .tool-versions 값 대신(또는 우선하여) 동적 기본값을 제안하게 한다.

핵심 결정 사항: 언제 fetch할지. 00_select.sh:284-288 주석이 지적한 phase 0 제약(asdf/플러그인 미보장, 네트워크 지연) 때문에 이 스크립트 실행 시점에 직접 fetch하는 게 부적절할 수 있음 — Story 1 조사 결론(118.3)에서 나온 시점/방식을 그대로 적용한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 ask_version()이 제안하는 기본값이 (조사에서 채택된 방식대로) 동적으로 갱신될 수 있음
- [x] #2 00_select.sh:284-288에 기록된 phase 0 제약이 재도입되지 않음(문서화된 근거대로 회피/우회됨)
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lib.sh에 lt_resolve_default_version <plugin> <static-default> 추가 - fetch +
static-fallback 결합, 00_select.sh가 아닌 lib.sh에 둠(00_select.sh는 최상위에서
mktemp/trap 등 부수효과가 있어 shellspec Include로 단위 테스트 불가 - lib.sh는
가능).

00_select.sh 통합 지점:
- lt_offer_language(): 사용자가 "Install <plugin>?"에 yes한 직후, ask_version()
  호출 전에 lt_resolve_default_version으로 그 언어 하나만 지연(lazy) 조회 -
  7개 전부를 미리 조회하지 않음(사용자가 실제로 선택한 언어만).
- companion(pnpm/gradle)도 동일 패턴 적용 - "Also install <companion>?"에
  yes한 직후에만 조회.
- ask_version()의 기존 phase-0 주석(00_select.sh:284-288 부근)에 이번 결정과의
  관계를 설명하는 주석 추가 - list-all 전체 브라우징을 하는 게 아니라 언어당
  단일 "latest" 조회 1회이며 asdf/플러그인 상태에 의존하지 않으므로 그 주석이
  지적한 문제를 재도입하지 않음을 명시.

fetch 시점 결정: 사용자가 이미 프롬프트 응답을 기다리는 시점(yes 답변 직후)에
지연 조회 - --all/비대화형 경로는 전혀 건드리지 않음(기존 select_spec.sh 5개
전부 그대로 통과, 네트워크 호출 없음 확인).

테스트: spec/lib_spec.sh에 Describe 'lt_resolve_default_version()' 4케이스
추가(성공/실패-폴백/미매핑-폴백/curl+git 둘 다 실패해도 안전). curl/git 전부 mock.

전체 스위트: shellspec (spec/ 전체) 146 examples, 0 failures.
shellcheck -s sh scripts/lib.sh scripts/install/00_select.sh: 기존 허용된
SC3043/SC2034/SC2155/SC1091 외 신규 경고 없음.
<!-- SECTION:NOTES:END -->
