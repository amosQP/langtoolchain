---
id: TASK-24
title: 실제 tty에서 제거 확인 프롬프트에 n 입력 시 취소
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:45'
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
- [x] #1 n 입력 시 '취소되었습니다' 메시지와 함께 exit 1로 종료되고 아무것도 제거되지 않는다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:45
---
expect로 진짜 pty를 구동해서 검증: uninstall/main.sh --dry-run 실행 후 '계속할까요?' 프롬프트에 'n' 입력 -> '취소되었습니다.' 출력 + exit 1, 어떤 phase도 실행되지 않고 즉시 종료됨을 확인.
---
<!-- COMMENTS:END -->
