---
id: TASK-121.2
title: lib.sh에 python 동반 도구 매핑 추가
status: To Do
assignee: []
created_date: '2026-08-30 12:01'
labels: []
dependencies:
  - TASK-121.1
parent_task_id: TASK-121
type: task
ordinal: 159000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
121.1에서 결정된 도구를 scripts/lib.sh:566-572 lt_companion_for_plugin()의 case 분기에 python -> 선정도구로 추가한다 (nodejs->pnpm, java->gradle과 동일한 패턴). .tool-versions에도 해당 도구의 기본 버전 항목을 추가해야 00_select.sh의 lt_offer_language()가 인식한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 lt_companion_for_plugin()이 python에 대해 선정된 도구 이름을 반환함
- [ ] #2 .tool-versions에 해당 도구의 기본 버전 항목이 추가됨
<!-- AC:END -->
