---
id: TASK-14
title: '빈 $HOME(zsh)에서 셸 설정 생성, brew shellenv가 최상단'
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - shell
dependencies: []
priority: medium
ordinal: 14000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
rc 파일이 전혀 없는 상태에서 04_configure_shell_env.sh를 실행하면 .zshrc가 새로 생기고, brew shellenv가 파일 맨 위(1번째 줄)에 위치하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 head -1 .zshrc가 eval "$(brew shellenv)" 줄이다
- [ ] #2 재실행해도 줄 수가 늘지 않는다(멱등성)
<!-- AC:END -->
