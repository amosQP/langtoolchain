---
id: TASK-125.3
title: 채택한 감지 장치 구현 및 CI 연결
status: To Do
assignee: []
created_date: '2026-09-03 01:14'
labels: []
dependencies:
  - TASK-125.2
parent_task_id: TASK-125
type: task
ordinal: 164000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-125.2에서 결정한 방식으로 감지 장치를 실제 구현하고, .github/workflows/e2e-verify.yml(또는 해당하는 CI 워크플로)에 게이트로 연결한다. 위반 시 CI가 실패해야 한다. 감지 장치 자체의 오탐 여부를 기존 통과 중인 스크립트들로 스모크 테스트.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 감지 장치가 구현되어 로컬에서 실행 가능함
- [ ] #2 CI 워크플로에 연결되어 위반 시 실패함
- [ ] #3 기존 통과 스크립트 대상 스모크 테스트에서 오탐 없음(또는 오탐이 있으면 원인이 문서화됨)
<!-- AC:END -->
