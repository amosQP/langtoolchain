---
id: TASK-129.3
title: 비대화형(--all/--yes/CI) 경로 회귀 없음 확인
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
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
