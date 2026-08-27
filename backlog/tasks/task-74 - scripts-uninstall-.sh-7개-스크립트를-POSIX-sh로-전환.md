---
id: TASK-74
title: scripts/uninstall/*.sh 7개 스크립트를 POSIX sh로 전환
status: Done
assignee: []
created_date: '2026-08-27 14:41'
updated_date: '2026-08-27 19:54'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies:
  - TASK-72
priority: high
type: chore
ordinal: 74000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_uninstall_runtimes.sh, 02_remove_plugins.sh, 03_clean_env_vars.sh, 04_remove_system_deps.sh, 05_purge_asdf_core.sh, 06_validate_teardown.sh, main.sh를 POSIX sh로 전환한다.
- shebang 전부 #!/usr/bin/env sh로
- ${BASH_SOURCE[0]} → $0
- [[ ]] → [ ], case문 활용
- 프로세스 치환 제거(01, 02, 03)
- 03_clean_env_vars.sh의 sed_args 배열 → 위치 매개변수로 대체
- main.sh가 각 phase를 bash로 실행하는 부분을 sh 실행으로 변경
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 7개 스크립트 전부 dash로 문법/실행 검증을 통과한다
- [x] #2 shellspec 관련 스펙이 그린을 유지한다(또는 POSIX 셸 기준으로 조정된다)
<!-- AC:END -->
