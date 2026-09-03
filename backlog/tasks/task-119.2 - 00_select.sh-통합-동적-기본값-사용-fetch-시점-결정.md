---
id: TASK-119.2
title: '00_select.sh 통합: 동적 기본값 사용 + fetch 시점 결정'
status: To Do
assignee: []
created_date: '2026-08-30 11:41'
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
- [ ] #1 ask_version()이 제안하는 기본값이 (조사에서 채택된 방식대로) 동적으로 갱신될 수 있음
- [ ] #2 00_select.sh:284-288에 기록된 phase 0 제약이 재도입되지 않음(문서화된 근거대로 회피/우회됨)
<!-- AC:END -->
