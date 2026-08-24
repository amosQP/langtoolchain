---
id: TASK-16
title: 알 수 없는 셸(fish 등)일 때 .zshrc로 폴백
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - shell
dependencies: []
priority: low
ordinal: 16000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
detect_rc_file이 zsh/bash가 아닌 셸에 대해 기본값(.zshrc)으로 폴백하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 SHELL=/usr/local/bin/fish일 때 .zshrc가 선택된다
<!-- AC:END -->
