---
id: TASK-36
title: 플래그 없이 비대화형 실행 시 전역이 기본값
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - version-scope
dependencies: []
priority: medium
ordinal: 36000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local 없이, tty도 없는 상태에서 00_select.sh가 스코프를 global로 기본 설정하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 선택 파일 첫 줄이 '# scope: global'이다
<!-- AC:END -->
