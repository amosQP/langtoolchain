---
id: TASK-121.3
title: 새 동반 도구 기본 버전을 TASK-119 헬퍼로 동적 조회 연결
status: To Do
assignee: []
created_date: '2026-08-30 12:01'
labels: []
dependencies:
  - TASK-121.2
  - TASK-119
parent_task_id: TASK-121
type: task
ordinal: 160000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-119(선택된 기본값 조회 방법 구현)에서 만든 버전 조회 헬퍼(예: lt_upstream_latest_version)가 121.2에서 추가한 새 동반 도구에도 적용되도록 연결한다. m-12가 목표하는 "정적 하드코딩 대신 동적 기본값"이 기존 7개 언어뿐 아니라 새로 추가되는 동반 도구에도 일관되게 적용되어야 함.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 새 동반 도구의 기본 버전도 TASK-119 헬퍼를 통해 동적으로 조회됨(정적 .tool-versions 값에만 의존하지 않음)
<!-- AC:END -->
