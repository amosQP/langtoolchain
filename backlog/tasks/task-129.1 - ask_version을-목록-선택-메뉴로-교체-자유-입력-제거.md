---
id: TASK-129.1
title: ask_version()을 목록 선택 메뉴로 교체 + 자유 입력 제거
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:34'
labels: []
dependencies: []
references:
  - decision-17
parent_task_id: TASK-129
type: task
ordinal: 178000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
ask_version()의 "default (default)" vs "Enter a specific version" 2지선다를, TASK-128
헬퍼가 반환한 실제 버전 목록을 lt_arrow_menu(00_select.sh:130-273 근방 기존 구현 재사용)로
보여주고 그 중 하나를 고르는 방식으로 바꾼다. read -r custom 자유 입력 경로는 완전히 제거한다.
default 값은 목록에서 강조 표시하거나 최상단에 배치해 기존 "빠르게 default로 진행" UX를
유지한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
ask_version()을 lt_arrow_menu 기반 실 버전 목록 선택으로 교체, 자유 텍스트 입력(read -r custom) 완전 제거. lib.sh에 lt_resolve_version_list()(캐시->실시간조회->실패, 서킷브레이커)와 lt_version_menu_options()(최대 15개 cap+default 중복제거) 추가(decision-17). 서킷브레이커는 ask_version이 커맨드서브스티튜션(서브셸)로 호출되는 걸 뒤늦게 발견해 변수 대신 마커 파일(LT_VERSION_LIST_UNREACHABLE_FILE, $$ 명명)로 구현 - 변수였다면 여러 언어에 걸쳐 조용히 무효했을 버그. 목록 조회 실패 시 자유입력 대신 default 하나뿐인 동일 메뉴로 폴백, 설치는 막지 않음. spec/lib_spec.sh에 9개 테스트 추가(Include 가능한 lib.sh로 두 헬퍼를 배치한 이유도 이 때문). select_spec.sh 비대화형 경로 회귀 없음 확인. 전체 shellspec 206->215 examples, 0 failures.
<!-- SECTION:FINAL_SUMMARY:END -->
