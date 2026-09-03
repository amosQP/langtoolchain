---
id: TASK-138.1
title: lt_run_with_timeout() 워치독 헬퍼 설계/구현
status: In Progress
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:12'
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
