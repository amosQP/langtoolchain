---
id: TASK-17
title: 동일 phase 재실행 시 멱등성
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - shell
dependencies: []
priority: medium
ordinal: 17000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
04_configure_shell_env.sh를 같은 rc 파일에 두 번 연속 실행해도 중복 줄이 추가되지 않는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 두 번 실행 후 파일의 총 줄 수가 한 번 실행했을 때와 동일하다
<!-- AC:END -->
