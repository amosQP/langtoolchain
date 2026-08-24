---
id: TASK-30
title: 주석/빈 줄/탭/트레일링 스페이스 섞인 .tool-versions 파싱
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - edge-case
dependencies: []
parent_task_id: TASK-49
priority: low
ordinal: 30000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
각종 지저분한 서식(주석, 빈 줄, 탭만 있는 줄, 트레일링 스페이스)이 섞인 .tool-versions를 each_tool이 정확히 파싱해서 유효한 언어/버전 줄만 추출하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 주석/빈 줄/탭 줄은 전부 무시되고, 유효한 줄의 트레일링 스페이스는 정상적으로 트리밍된다
<!-- AC:END -->
