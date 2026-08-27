---
id: TASK-73
title: scripts/install/*.sh 8개 스크립트를 POSIX sh로 전환
status: Done
assignee: []
created_date: '2026-08-27 14:41'
updated_date: '2026-08-27 19:50'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies:
  - TASK-72
priority: high
type: chore
ordinal: 73000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
00_select.sh, 01_bootstrap_asdf.sh, 02_install_plugins.sh, 03_install_system_deps.sh, 04_configure_shell_env.sh, 05_install_runtimes.sh, 06_set_globals.sh, 07_validate.sh, main.sh를 POSIX sh로 전환한다.
- shebang 전부 #!/usr/bin/env sh로
- ${BASH_SOURCE[0]} → $0 (모든 파일의 SCRIPT_DIR 계산부)
- [[ ]] → [ ], 패턴/glob 매칭이 필요한 곳은 case문으로
- while read ... done < <(cmd) 프로세스 치환 패턴(02, 05, 06, 07, 00) → 임시파일 기반 읽기로 재작성. 서브셸 변수 스코프 문제(파이프-to-while)가 재발하지 않도록 주의(원래 lib.sh 주석이 경고하던 바로 그 문제)
- main.sh의 SELECT_OPTS 배열 → 위치 매개변수(set --)로 대체
- main.sh가 각 phase를 bash로 직접 실행하는 부분(bash "$SCRIPT_DIR/$phase")을 sh 실행으로 변경
- 00_select.sh의 인터랙티브 프롬프트/scope 처리 로직이 동작 변화 없이 유지되는지 특히 주의
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 8개 스크립트 전부 dash로 문법/실행 검증을 통과한다
- [x] #2 프로세스 치환이 전부 제거되고 대체 패턴이 서브셸 변수 스코프 문제를 일으키지 않는다
- [x] #3 shellspec 관련 스펙이 그린을 유지한다(또는 POSIX 셸 기준으로 조정된다)
<!-- AC:END -->
