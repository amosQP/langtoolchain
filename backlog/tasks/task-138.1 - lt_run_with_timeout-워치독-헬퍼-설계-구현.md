---
id: TASK-138.1
title: lt_run_with_timeout() 워치독 헬퍼 설계/구현
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:16'
labels: []
dependencies: []
parent_task_id: TASK-138
type: task
ordinal: 199000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
decision-10이 권고한 방식: 명령을 백그라운드로 실행 + 별도 감시 프로세스가 LT_VERSION_
FETCH_TIMEOUT 이후 kill. POSIX sh(dash 포함)에서 동작해야 하므로 bash 전용 기능(wait -n,
$EPOCHREALTIME 등) 없이 구현한다. lib.sh에 lt_run_with_timeout() 같은 이름으로 추가하고,
docs/shell-style-guide.md 컨벤션(네이밍/주석 헤더/따옴표)을 따른다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
lt_run_with_timeout(seconds, cmd...) 구현: 백그라운드 job + 워치독 서브셸(sleep+kill -TERM) 패턴, POSIX sh/dash 호환. 타임아웃 시 124 반환, 정상 종료 시 원래 종료코드 반환. spec/lib_spec.sh에 4개 케이스(정상 성공/실패 전파/조기 반환/타임아웃 킬) 추가, shellcheck·dash -n·shellspec(bash+dash) 전부 통과(99 examples, 0 failures).
<!-- SECTION:FINAL_SUMMARY:END -->
