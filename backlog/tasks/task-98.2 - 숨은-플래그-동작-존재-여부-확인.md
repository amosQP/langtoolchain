---
id: TASK-98.2
title: 숨은 플래그/동작 존재 여부 확인
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-98
type: task
ordinal: 111000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
main.sh/00_select.sh의 case문에서 README에 문서화 안 된 플래그나 분기가 있는지 grep으로 대조.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 완료 - 숨은 플래그 없음. install/main.sh(--dry-run/--all/--yes/--local/--local=*), uninstall/main.sh(--dry-run/--yes), 00_select.sh의 case문 전부 README 옵션 플래그 표와 1:1 대조 확인, 문서에 없는 분기 없음.
<!-- SECTION:NOTES:END -->
