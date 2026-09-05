---
id: TASK-128.2
title: 동반 도구(pnpm/gradle 등)에도 전체 목록 조회 확장
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 08:56'
labels: []
dependencies:
  - TASK-128.1
parent_task_id: TASK-128
type: task
ordinal: 175000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
128.1의 목록 조회 헬퍼를 동반 도구(pnpm, gradle, 그리고 TASK-121에서 python 동반 도구가
정해지면 그것까지)에도 적용한다. 동반 도구는 asdf plugin이 아닌 경우도 있으므로(TASK-99/100
매핑 로직 참고) 언어 런타임과 조회 방식이 다를 수 있음을 감안해서 구현한다.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 결과: 현재 동반 도구(pnpm/gradle/uv) 3개는 전부 실제 asdf 플러그인 이름 그 자체 -
00_select.sh의 lt_offer_language()가 이미 lt_resolve_default_version()을 companion
plugin 이름에 그대로 호출하는 것과 동일한 패턴. TASK-128.1에서 lt_upstream_version_list()
case문에 pnpm/gradle/uv 분기를 이미 전부 구현해뒀으므로, 128.2에서 새 case 분기 코드 추가는
불필요 - 대신 (1) lt_companion_for_plugin()의 출력이 실제로 lt_upstream_version_list()의
동작하는 분기로 이어지는지 end-to-end로 검증하는 테스트 추가, (2) 함수 주석에 "TASK-99/100이
언급한 '동반 도구가 asdf 플러그인이 아닐 수도 있다'는 가능성은 현재 존재하는 3개 동반 도구
중 어디에도 해당하지 않는다"는 점을 명시.

spec/lib_spec.sh에 새 Describe 블록 추가(4개 example): nodejs->pnpm, java->gradle,
python->uv 각각 lt_companion_for_plugin()으로 이름을 얻어 lt_upstream_version_list()에
넘기는 통합 테스트 + rust/golang은 애초에 동반 도구가 없음(설계상 의도, lt_companion_
for_plugin() 자체 주석 참고) 확인. bash/dash 양쪽 117 examples 0 failures(128.1의 113
-> 117). shellcheck 신규 경고 0건.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
동반 도구(pnpm/gradle/uv) 3개 전부 TASK-128.1에서 이미 lt_upstream_version_list()의
case 분기로 구현되어 있음을 확인(플러그인 이름 그 자체라 별도 코드 불필요). 이 태스크의
실제 산출물은 lt_companion_for_plugin() -> lt_upstream_version_list() 연결을 검증하는
통합 테스트 4개(spec/lib_spec.sh) + 함수 주석에 "동반 도구가 asdf 플러그인이 아닐 수
있다"는 TASK-99/100 우려가 현재 3개 동반 도구 중 어디에도 해당하지 않는다는 점을 명시.
bash/dash 양쪽 shellspec 117 examples 0 failures(128.1의 113 -> 117), shellcheck
신규 경고 0건.
<!-- SECTION:FINAL_SUMMARY:END -->
