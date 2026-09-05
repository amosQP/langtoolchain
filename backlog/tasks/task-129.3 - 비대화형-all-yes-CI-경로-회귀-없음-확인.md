---
id: TASK-129.3
title: 비대화형(--all/--yes/CI) 경로 회귀 없음 확인
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:39'
labels: []
dependencies:
  - TASK-129.2
parent_task_id: TASK-129
type: task
ordinal: 180000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--all/--yes 플래그나 tty 없는 CI 실행 경로(TASK-95, TASK-95.1)는 지금도 ask_version()을
안 거치고 DEFAULT_CONFIG를 그대로 쓴다(00_select.sh:313-332). 이번 UI 교체가 이 경로에
영향을 주지 않는지 확인하고, 관련 shellspec(select_spec.sh 등)이 계속 통과하는지 검증한다.
<!-- SECTION:DESCRIPTION:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-09-05 09:39
---
확인 결과: --all/--yes/no-tty 경로(00_select.sh의 INTERACTIVE/SELECT_ALL 분기, ~line 543 부근)는 lt_offer_language()/ask_version()에 전혀 도달하지 않고 DEFAULT_CONFIG를 그대로 write_with_scope로 써서 exit 0 - TASK-129.1/129.2의 UI 교체(lt_arrow_menu 기반 목록 선택, lib.sh의 lt_resolve_version_list/lt_version_menu_options 추가)는 구조적으로 이 경로에 영향 없음. 00_select.sh EXIT trap에 추가한 'rm -f $LT_VERSION_LIST_UNREACHABLE_FILE'도 이 경로에서 파일이 애초에 생성된 적이 없어 안전한 no-op. 실제로 './scripts/install/00_select.sh --all' 수동 실행 + spec/select_spec.sh(5 examples) 재실행으로 확인, 전체 회귀 없음(spec/lib_spec.sh 포함 139 examples, 0 failures).
---
<!-- COMMENTS:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
--all/--yes/CI(no-tty) 경로는 ask_version()에 전혀 도달하지 않는다는 걸 코드 확인(00_select.sh의 INTERACTIVE/SELECT_ALL 분기가 lt_offer_language 루프보다 먼저 exit)했고, 실제로 './scripts/install/00_select.sh --all' 수동 실행으로 8개 언어/동반도구가 모두 정상 기록됨을 확인. TASK-129.1/129.2에서 추가한 lib.sh의 새 함수(lt_resolve_version_list, lt_version_menu_options)와 00_select.sh EXIT trap의 마커파일 정리 둘 다 이 경로에 영향 없음(마커파일이 애초에 안 생기므로 rm -f는 no-op). spec/select_spec.sh(5 examples) + spec/lib_spec.sh 재실행, 회귀 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
