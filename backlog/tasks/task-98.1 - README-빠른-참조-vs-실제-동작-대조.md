---
id: TASK-98.1
title: README 빠른 참조 vs 실제 동작 대조
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:27'
labels: []
dependencies: []
parent_task_id: TASK-98
type: task
ordinal: 110000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
README의 빠른 참조 명령어 목록을 실제로 하나씩 --dry-run으로 실행해보며 문서와 동작이 100% 일치하는지 대조.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
대조 완료. install/uninstall 단계 표(150-158행), --dry-run/--all/--yes/--local 설명 전부 실제 동작과 일치. 단 하나 gap: install 섹션엔 tty-없음 자동 폴백 안내(109행)가 있는데 uninstall 섹션엔 동일한 안내가 없음 — TASK-97.1에서 확인한 실제 동작(raw stderr 노출)과 연결됨. 문서 자체의 잘못이라기보단 그 동작이 install처럼 의도적으로 다뤄진 적이 없어서 생긴 공백.
<!-- SECTION:NOTES:END -->
