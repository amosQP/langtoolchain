---
id: TASK-24
title: 실제 tty에서 제거 확인 프롬프트에 n 입력 시 취소
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - uninstall
dependencies: []
parent_task_id: TASK-46
priority: low
ordinal: 24000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--yes로 우회하지 않고 실제 키 입력으로 uninstall의 '계속할까요? [y/N]' 프롬프트에 n을 입력했을 때 정상적으로 취소되는지 확인. 지금까지는 --yes로만 검증했다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 n 입력 시 '취소되었습니다' 메시지와 함께 exit 1로 종료되고 아무것도 제거되지 않는다
<!-- AC:END -->
