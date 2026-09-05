---
id: TASK-129.2
title: 버전 목록이 길 때(수십~수백개) UX 처리
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:35'
labels: []
dependencies:
  - TASK-129.1
references:
  - decision-17
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

created: 2026-09-05 09:35
---
TASK-129.1 구현 시 이 태스크의 두 항목을 함께 처리했다(commit 7065554, decision-17): (1) 긴 목록 UX - lt_arrow_menu를 확장하는 대신 LT_VERSION_MENU_MAX(=15)로 '최근 N개 우선 노출' 방식 cap 적용(lt_version_menu_options(), lib.sh) - 스크롤/페이지네이션은 화면 전체 재출력 구조상 과설계로 판단해 보류. (2) 코드리뷰 코멘트의 순차조회 지연 - lt_resolve_version_list()에 세션 단위 서킷브레이커(LT_VERSION_LIST_UNREACHABLE_FILE, 마커 파일) 추가로 목록조회분 지연을 timeout×N에서 timeout×1로 줄임. lt_resolve_default_version() 자체의 지연은 범위 밖으로 명시 보류(decision-17 '범위 밖으로 남기는 것' 참고). spec/lib_spec.sh에 cap/circuit-breaker 단위테스트 포함.
---
<!-- COMMENTS:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
긴 버전 목록(node/java 등 수십~수백개) UX와 코드리뷰가 지적한 순차조회 지연 문제 둘 다 TASK-129.1 구현(commit 7065554)에서 함께 처리됨 - decision-17 참고. (1) lt_arrow_menu 확장/페이지네이션 대신 lt_version_menu_options()가 LT_VERSION_MENU_MAX(15)로 '최근 N개'만 노출하는 전처리 단계를 추가(개인 툴링 규모 대비 과설계 방지). (2) lt_resolve_version_list()에 세션 서킷브레이커(마커 파일 LT_VERSION_LIST_UNREACHABLE_FILE) 추가로 오프라인 시 지연을 timeout×N에서 timeout×1(목록조회분)로 축소. lt_resolve_default_version() 자체 지연은 TASK-119 소유 코드라 범위 밖으로 명시 보류. shellspec: spec/lib_spec.sh에 cap(정확히 5/15 cap, dedup, 빈 목록) + 서킷브레이커(트립, 트립후 스킵, 트립후에도 캐시히트는 통과) 테스트 포함, 전체 스위트 206->215 examples 0 failures.
<!-- SECTION:FINAL_SUMMARY:END -->
