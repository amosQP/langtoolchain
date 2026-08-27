---
id: TASK-77
title: pure-sh-bible 검토 후 uninstall/02_remove_plugins.sh의 트레일링 개행 누락 버그 수정
status: Done
assignee: []
created_date: '2026-08-27 20:08'
updated_date: '2026-08-27 20:08'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies: []
priority: low
type: bug
ordinal: 77000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
pure-sh-bible(https://github.com/dylanaraps/pure-sh-bible)을 다운받아 검토, 프로젝트에 적용 가능한 부분을 확인했다. 대부분(색 이스케이프, 산술 연산자 표, is_int/is_float, dirname/basename 순수 재구현, 글롭 존재 체크)은 해당 없거나 이미 다른 방식으로 커버돼서 적용 안 함. 실제로 발견한 실버그 1건: uninstall/02_remove_plugins.sh가 'asdf plugin list'(우리가 통제 안 하는 외부 명령) 출력을 'while read' 루프로 읽는데, 마지막 줄에 트레일링 개행이 없으면 read가 EOF에서 실패로 반환하면서 그 값을 조용히 버린다 — 마지막 asdf plugin이 제거 대상에서 누락될 수 있었음. 나머지 read 루프(each_tool/lt_env_var_defs 출력 등)는 전부 이 저장소 자신의 printf 기반이라 항상 개행으로 끝나서 해당 없음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 while read -r plugin <&3 || [ -n "$plugin" ]로 고쳐서 트레일링 개행 없는 마지막 줄도 처리한다
- [x] #2 트레일링 개행 없는 목록으로 실제 재현/검증한다
<!-- AC:END -->
