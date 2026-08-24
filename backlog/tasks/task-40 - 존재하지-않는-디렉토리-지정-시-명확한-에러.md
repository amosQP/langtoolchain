---
id: TASK-40
title: 존재하지 않는 디렉토리 지정 시 명확한 에러
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - version-scope
dependencies: []
priority: medium
ordinal: 40000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local=/nonexistent/path처럼 존재하지 않는 디렉토리를 지정했을 때 조용히 실패하지 않고 명확한 에러 메시지로 종료되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 'Directory not found' 류의 메시지와 함께 exit 1로 종료된다
<!-- AC:END -->
