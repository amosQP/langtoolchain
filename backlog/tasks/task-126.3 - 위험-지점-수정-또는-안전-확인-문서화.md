---
id: TASK-126.3
title: 위험 지점 수정 또는 안전 확인 문서화
status: To Do
assignee: []
created_date: '2026-09-03 01:15'
labels: []
dependencies:
  - TASK-126.2
parent_task_id: TASK-126
type: task
ordinal: 169000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-126.2 평가 결과에 따라: 실제 위험 지점이 있으면 이식성 있는 형태(예: printf로 임시파일 후 mv, 또는 -i.bak 형태 등 BSD/GNU 공통 동작)로 수정한다. 위험 지점이 없다면 코드를 억지로 고치지 않고 감사 결과(무엇을 확인했고 왜 안전한지)를 이 태스크의 final summary에 문서화하고 종료한다. 없는 문제를 만들어 고치지 않는다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 위험 지점이 있었다면 수정되고 관련 shellspec/실행 검증을 통과함
- [ ] #2 위험 지점이 없었다면 감사 결과가 final summary에 문서화됨
<!-- AC:END -->
