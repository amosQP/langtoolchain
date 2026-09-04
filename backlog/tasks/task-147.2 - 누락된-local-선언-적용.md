---
id: TASK-147.2
title: 누락된 local 선언 적용
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
labels: []
dependencies:
  - TASK-147.1
parent_task_id: TASK-147
type: task
ordinal: 220000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
147.1 스캔 결과에 local을 추가한다. docs/shell-style-guide.md 컨벤션(local 선언과 대입을
분리해야 하는 경우 - 명령 치환 결과를 담을 때)도 함께 지킨다. 순수 스코핑 수정이므로 동작이
바뀌면 안 된다 — 매 파일 수정 후 관련 shellspec으로 회귀 없음을 확인.
<!-- SECTION:DESCRIPTION:END -->
