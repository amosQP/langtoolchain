---
id: TASK-128.3
title: 목록 캐싱 + 네트워크 실패 시 폴백 구현
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
labels: []
dependencies:
  - TASK-128.2
parent_task_id: TASK-128
type: task
ordinal: 176000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-127.2에서 설계한 캐싱 전략을 실제로 구현한다: 목록을 로컬에 캐시하고, 네트워크 조회
실패 시 마지막 캐시 또는 .tool-versions에 있는 값으로 폴백한다(TASK-119.3의 폴백 로직과의
통합 여부는 127.2 결정을 따른다). 오프라인 상태에서도 설치 자체는 막히지 않아야 한다.
<!-- SECTION:DESCRIPTION:END -->
