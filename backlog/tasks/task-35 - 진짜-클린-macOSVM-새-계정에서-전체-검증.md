---
id: TASK-35
title: 진짜 클린 macOS(VM/새 계정)에서 전체 검증
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - platform
dependencies: []
priority: high
ordinal: 35000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
기존 설정이 전혀 없는 진짜 클린 상태(가상머신 또는 새 macOS 사용자 계정)에서 Homebrew 자동 설치 경로를 포함해 curl 한 줄부터 끝까지 전체 흐름을 검증. 이번 세션의 실기기 테스트는 전부 이미 Homebrew/asdf가 설치돼 있던 개발 머신에서 진행됐다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Homebrew도 asdf도 전혀 없는 상태에서 curl | bash 한 줄로 끝까지 설치가 완료된다
<!-- AC:END -->
