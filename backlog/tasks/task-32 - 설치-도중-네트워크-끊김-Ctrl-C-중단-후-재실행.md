---
id: TASK-32
title: 설치 도중 네트워크 끊김/Ctrl-C 중단 후 재실행
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - edge-case
dependencies: []
parent_task_id: TASK-49
priority: medium
ordinal: 32000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
런타임 다운로드/컴파일 도중 네트워크가 끊기거나 Ctrl-C로 중단된 뒤, 설치를 다시 실행했을 때 정상적으로 이어지거나 최소한 안전하게 실패하는지 확인(부분 설치 상태로 인한 이상 동작이 없는지).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 중단 후 재실행 시 이미 완료된 phase는 다시 반복하지 않거나, 반복해도 안전하다(멱등적이다)
- [ ] #2 부분적으로 설치된 언어가 있어도 다른 언어의 설치를 막지 않는다
<!-- AC:END -->
