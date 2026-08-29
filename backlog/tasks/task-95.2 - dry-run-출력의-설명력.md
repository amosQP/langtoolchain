---
id: TASK-95.2
title: dry-run 출력의 설명력
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-95
type: task
ordinal: 112000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
DRY_RUN=true일 때 각 phase가 찍는 '+ ...' 미리보기 로그만 보고 사용자가 실제 무슨 변경이 일어날지 충분히 예측할 수 있는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 완료. --dry-run 로그가 'brew install ...', 'asdf install ...' 등 실제 실행될 명령어를 그대로 보여줘서 사용자가 무슨 일이 일어날지 충분히 예측 가능함을 라이브 실행으로 확인.
<!-- SECTION:NOTES:END -->
