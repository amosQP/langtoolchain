---
id: TASK-26
title: tty 없는 환경에서 자동 전체 설치 폴백
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - interactive
dependencies: []
priority: medium
ordinal: 26000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/dev/tty를 열 수 없는 환경(CI 등)에서 입력 대기 없이 자동으로 --all과 동일하게 동작하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 tty가 없으면 즉시 전체 언어가 선택된 파일을 반환하고 멈추지 않는다
<!-- AC:END -->
