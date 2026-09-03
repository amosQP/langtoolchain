---
id: TASK-129.2
title: 버전 목록이 길 때(수십~수백개) UX 처리
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-03 11:08'
labels: []
dependencies:
  - TASK-129.1
parent_task_id: TASK-129
type: task
ordinal: 179000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
node/java 등은 설치 가능 버전이 수십~수백 개에 달할 수 있다. lt_arrow_menu가 지금 지원하는
범위(고정 개수 옵션 나열)로 그대로 쓰기 어려울 수 있으므로, 스크롤/페이지네이션, 또는 "최근
N개 + LTS/안정 버전 우선 노출" 같은 필터링이 필요한지 검토하고 필요하면 lt_arrow_menu를
확장하거나 목록 표시 전 전처리 단계를 추가한다.
<!-- SECTION:DESCRIPTION:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-09-03 11:08
---
참고 (/code-review high, 2026-09-03): 00_select.sh의 lt_offer_language()가 언어/동반
도구 선택마다 lt_resolve_default_version()을 동기 순차 호출해서(현재 병렬/prefetch 없음)
여러 개 고르면 최대 LT_VERSION_FETCH_TIMEOUT(기본 5초)×N만큼 지연될 수 있다는 지적이
있었음. 새 태스크로 분리하지 않고 여기(목록이 길 때 UX 처리) 범위에 포함해서 같이 다룬다 —
이 태스크가 다루는 "목록 기반 선택 UI" 자체가 조회 아키텍처를 다시 설계하므로.
---
<!-- COMMENTS:END -->
