---
id: TASK-102
title: uninstall 대칭성 확인
status: To Do
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:41'
labels: []
milestone: m-7
dependencies:
  - TASK-99
  - TASK-100
type: task
ordinal: 117000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_uninstall_runtimes.sh/02_remove_plugins.sh/06_set_globals.sh 등은 each_tool()로 .tool-versions를 범용적으로 순회하는 구조라 pnpm/gradle을 추가해도 코드 변경 없이 자동으로 대칭 처리될 것으로 예상 — 실제로 uninstall 시 정상적으로 같이 제거되는지 --dry-run으로 검증만.
<!-- SECTION:DESCRIPTION:END -->
