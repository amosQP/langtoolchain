---
id: TASK-140.2
title: 위반 사례 심각도 분류 및 처리
status: To Do
assignee: []
created_date: '2026-09-03 12:07'
labels: []
dependencies:
  - TASK-140.1
parent_task_id: TASK-140
type: task
ordinal: 207000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
140.1 스캔 결과를 심각도로 분류한다: (a) 사소하고 국소적인 것(예: 라인 길이 몇 자 초과,
주석 헤더 누락)은 이 태스크에서 바로 고친다 — 동작 변경 없는 순수 스타일 수정이므로
shellspec 전후 동일 통과만 확인하면 됨. (b) 광범위하거나 구조적 변경이 필요한 것은 고치지
않고 별도 태스크로 분리해서 backlog에 기록만 한다(스코프를 감사+국소 수정으로 한정).
"발견된 위반 없음"도 유효한 결과다 — 없는 문제를 만들어 고치지 않는다.
<!-- SECTION:DESCRIPTION:END -->
