---
id: TASK-121.2
title: lib.sh에 python 동반 도구 매핑 추가
status: Done
assignee: []
created_date: '2026-08-30 12:01'
updated_date: '2026-09-03 11:27'
labels: []
dependencies:
  - TASK-121.1
parent_task_id: TASK-121
type: task
ordinal: 159000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
121.1에서 결정된 도구를 scripts/lib.sh:566-572 lt_companion_for_plugin()의 case 분기에 python -> 선정도구로 추가한다 (nodejs->pnpm, java->gradle과 동일한 패턴). .tool-versions에도 해당 도구의 기본 버전 항목을 추가해야 00_select.sh의 lt_offer_language()가 인식한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 lt_companion_for_plugin()이 python에 대해 선정된 도구 이름을 반환함
- [x] #2 .tool-versions에 해당 도구의 기본 버전 항목이 추가됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lib.sh: lt_companion_for_plugin()의 python) 케이스에 uv 추가(decision-5).
.tool-versions: python 다음 줄에 "uv 0.12.9" 추가(2026-09-03 기준 실측 최신값,
GitHub Releases API로 확인).

binary_for_plugin()/flag_for_binary()는 변경 불필요 - 둘 다 unknown-plugin
기본 케이스(*)가 각각 "$1 그대로"/"--version"을 반환하는데, uv의 실제 바이너리
이름/버전플래그가 정확히 "uv"/"--version"이라 기본 동작으로 이미 맞음
(scripts/install/07_validate.sh의 validate_one_tool()이 이 두 함수를 통해
설치 후 검증하므로 실제 동작 경로 확인됨).

기존 테스트 수정: spec/lib_spec.sh의 "has no companion for python" 케이스가
"maps python -> uv"로 대체됨(요구사항이 바뀐 것이므로 - 새 테스트 추가가 아니라
기존 잘못된 기대값 수정).

전체 스위트: shellspec (spec/ 전체) 149 examples, 0 failures.
shellcheck -s sh scripts/lib.sh: 신규 경고 없음.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-121.1 결정(decision-5)에 따라 lib.sh의 lt_companion_for_plugin() python) 케이스에 uv를 추가(nodejs->pnpm, java->gradle과 동일한 패턴), .tool-versions에 uv 기본 버전(0.12.9, 실측 최신값) 항목을 추가해 00_select.sh의 lt_offer_language()가 인식하게 함. binary_for_plugin()/flag_for_binary()는 unknown-plugin 기본 케이스(*)가 이미 uv의 실제 바이너리명/버전플래그(uv/--version)와 일치해 변경 불필요(07_validate.sh의 validate_one_tool() 검증 경로로 확인). 기존 spec/lib_spec.sh의 'has no companion for python' 케이스를 'maps python -> uv'로 수정(요구사항 변경 반영). 전체 스위트(spec/ 전체) 149 examples 0 failures, shellcheck 신규 경고 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
