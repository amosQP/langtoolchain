---
id: TASK-129
title: '00_select.sh 선택 UI를 실 목록 기반으로 교체, 자유 텍스트 입력 제거'
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:42'
labels: []
milestone: m-15
dependencies:
  - TASK-128
references:
  - TASK-95
priority: medium
type: task
ordinal: 177000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/00_select.sh:282-298의 ask_version()을 TASK-128에서 만든 목록 조회 헬퍼를
써서 lt_arrow_menu 기반 "실제 조회된 버전 목록에서 선택"으로 교체하고, 현재 있는
"Enter a specific version" 자유 텍스트 입력 경로(read -r custom)를 제거한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
00_select.sh의 ask_version()을 default-vs-자유텍스트 2지선다에서 lt_arrow_menu 기반 실제 버전 목록 선택으로 완전 교체(read -r custom 자유입력 경로 삭제). 3개 자식 태스크 전부 Done: (129.1) lib.sh에 lt_resolve_version_list(캐시->실시간조회->실패)/lt_version_menu_options(cap+dedup) 추가, 목록 조회 실패 시 default 하나뿐인 동일 위젯으로 폴백해 설치를 막지 않음(decision-17). (129.2) 긴 목록(node/java 수십~수백개)은 LT_VERSION_MENU_MAX=15로 '최근 N개' cap 처리(lt_arrow_menu 자체 확장은 과설계로 판단해 보류), 코드리뷰가 지적한 순차조회 지연은 세션 서킷브레이커(마커 파일 LT_VERSION_LIST_UNREACHABLE_FILE)로 timeout×N을 timeout×1로 축소 - lt_resolve_default_version() 자체 지연은 TASK-119 소유라 범위 밖으로 명시 보류. (129.3) --all/--yes/no-tty 경로는 ask_version()에 도달하지 않아 구조적으로 영향 없음을 코드 확인 + 수동 실행 + select_spec.sh로 검증. 구현 중 서킷브레이커를 처음엔 평범한 셸 변수로 짰다가, ask_version()이 커맨드서브스티튜션(서브셸)으로 호출된다는 걸 뒤늦게 발견해 마커 파일 방식으로 교정한 버그를 스스로 잡았음(decision-17에 기록). 순수 로직 2개 헬퍼는 이 저장소 shellspec 관례상 Include 단위테스트가 가능한 lib.sh에 배치, spec/lib_spec.sh에 9개 테스트 추가. 전체 shellspec: 206->215 examples, 0 failures(회귀 없음). m-15 마일스톤 마지막 태스크 완료.
<!-- SECTION:FINAL_SUMMARY:END -->
