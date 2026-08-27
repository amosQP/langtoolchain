---
id: TASK-28
title: 버전 직접 입력(기본값 override) 시나리오
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:45'
labels:
  - test
  - interactive
dependencies: []
parent_task_id: TASK-47
priority: low
ordinal: 28000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
언어 선택 시 기본값 대신 사용자가 직접 다른 버전 문자열을 입력했을 때, 그 값이 선택 파일에 정확히 반영되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 임의의 버전 문자열을 입력하면 선택 파일에 기본값이 아니라 입력한 값이 기록된다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:45
---
expect로 진짜 pty 구동 검증: nodejs 버전 프롬프트에 '99.99.99-custom-test' 입력 -> 선택 파일에 기본값(lts) 대신 정확히 그 값이 기록됨을 확인.
---
<!-- COMMENTS:END -->
