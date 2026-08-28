---
id: TASK-80
title: install/main.sh가 phase 실패 시 선택 파일 임시파일을 안 지움
status: Done
assignee: []
created_date: '2026-08-28 04:26'
updated_date: '2026-08-28 04:33'
labels:
  - bug
  - shell
milestone: m-2
dependencies: []
priority: low
type: bug
ordinal: 80000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install/main.sh는 SELECTION_FILE(00_select.sh가 mktemp로 만든 임시 선택 파일)을 모든 phase(01~07)가 성공적으로 끝난 뒤 맨 마지막에만 rm -f 한다. set -eu 하에서 phase 중 하나(예: 05_install_runtimes.sh의 네트워크 문제)가 실패하면 스크립트가 그 즉시 죽고 rm -f 줄에 도달하지 못해 임시 선택 파일이 남는다. 기능적으로 치명적이지 않지만(다음 실행은 자기 선택 파일을 새로 만듦), 00_select.sh 자신은 이미 동일한 파일을 위해 EXIT trap(SUCCESS가 false면 지움)을 쓰고 있어서 비대칭적이다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 install/main.sh도 EXIT trap으로 SELECTION_FILE을 정리해서 중간 실패 시에도 임시파일이 안 남는다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 04:33
---
SELECTION_FILE 설정 직후 trap 'rm -f "$SELECTION_FILE"' EXIT 추가, 기존 스크립트 끝의 수동 rm -f는 제거(trap이 대체). 독립 셸 스니펫으로 중간 실패 시에도 정리되는 것 확인, shellspec 65/65(bash+dash) 통과.
---
<!-- COMMENTS:END -->
