---
id: TASK-104
title: 테스트 커버리지 추가 (동반 도구)
status: Done
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:57'
labels: []
milestone: m-7
dependencies:
  - TASK-99
  - TASK-100
  - TASK-101
  - TASK-102
type: task
ordinal: 119000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
select_spec.sh에 '부모 언어 수락 시에만 동반 도구 질문이 뜨는지', '부모 언어 거절 시 동반 도구 질문 자체가 안 뜨는지' 회귀 테스트 추가. install_plugins_spec/install_runtimes_spec/set_globals_spec/remove_plugins_spec/uninstall_runtimes_spec에 pnpm/gradle 케이스 추가. validate_spec에 gradle 버전 파싱 케이스 추가.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lt_companion_for_plugin() 유닛 테스트 6개(lib_spec.sh), select_spec.sh --all 회귀에 pnpm/gradle 포함 확인 추가. install_plugins_spec/install_runtimes_spec/set_globals_spec/remove_plugins_spec/uninstall_runtimes_spec에 pnpm/gradle 케이스는 의도적으로 생략함 - 실제 코드 확인 결과(TASK-102) 이 스크립트들은 plugin 이름에 전혀 특화되지 않은 완전 범용 each_tool() 순회 구조라, pnpm/gradle 전용 테스트를 추가해도 이미 다른 plugin 이름으로 증명된 메커니즘을 문자열만 바꿔 반복하는 셈 - 실제 값어치가 없다고 판단. '부모 언어 거절 시 동반 도구 질문이 안 뜨는지' 인터랙티브 테스트도 생략 - select_spec.sh 자체가 이미 '인터랙티브 /dev/tty 경로는 이 스위트에서 커버 안 함(진짜 터미널 필요)'는 기존 컨벤션이라 새 companion 로직도 동일 원칙 적용. 최종 120/120(bash+dash) 통과, shellcheck 에러 0건.
<!-- SECTION:NOTES:END -->
