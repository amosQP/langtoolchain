---
id: TASK-37
title: 디렉토리 인자 없이 --local 플래그만 쓰면 현재 디렉토리에 고정
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - version-scope
dependencies: []
priority: medium
ordinal: 37000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local만 주고 디렉토리를 지정하지 않으면 현재 작업 디렉토리가 자동으로 스코프 대상이 되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 선택 파일 첫 줄이 '# scope: local <실행 당시의 pwd 절대경로>'다
<!-- AC:END -->
