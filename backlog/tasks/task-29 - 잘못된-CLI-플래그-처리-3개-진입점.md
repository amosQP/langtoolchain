---
id: TASK-29
title: 잘못된 CLI 플래그 처리 (3개 진입점)
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - edge-case
dependencies: []
parent_task_id: TASK-49
priority: medium
ordinal: 29000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh, scripts/install/main.sh, scripts/uninstall/main.sh 각각에 존재하지 않는 플래그를 줬을 때 명확한 에러 메시지와 함께 exit 1로 종료되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 세 진입점 모두 'Unknown option' 류의 메시지를 내고 exit 1로 종료한다
<!-- AC:END -->
