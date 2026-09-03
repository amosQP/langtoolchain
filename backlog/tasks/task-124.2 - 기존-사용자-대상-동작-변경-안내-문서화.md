---
id: TASK-124.2
title: 기존 사용자 대상 동작 변경 안내 문서화
status: To Do
assignee: []
created_date: '2026-08-30 12:01'
labels: []
dependencies:
  - TASK-124.1
parent_task_id: TASK-124
type: docs
ordinal: 157000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이 변경 전 버전의 uninstall.sh를 이미 써본 적 있는 사용자, 또는 이 변경 이후에도 스냅샷 없이 uninstall을 실행하게 될 사용자를 위해 README/CHANGELOG에 동작 변경을 안내한다: "이제 uninstall은 langtoolchain 설치 전부터 있던 asdf 상태를 보존하려 시도하며, 스냅샷이 없으면 안전을 위해 삭제를 건너뛰고 수동 정리 방법을 안내한다"는 내용.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 README(한/영 양쪽)에 uninstall 동작 변경이 명시됨
<!-- AC:END -->
