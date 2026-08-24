---
id: TASK-38
title: 디렉토리를 지정한 --local=path로 그 디렉토리에 고정
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - version-scope
dependencies: []
priority: medium
ordinal: 38000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local=DIR로 명시적으로 지정한 디렉토리가 스코프 대상이 되고, 06_set_globals.sh가 실제로 그 디렉토리에 .tool-versions를 생성하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 지정한 디렉토리에 .tool-versions 파일이 실제로 생성되고 내용이 정확하다
- [ ] #2 전역 ~/.tool-versions는 변경되지 않는다
<!-- AC:END -->
