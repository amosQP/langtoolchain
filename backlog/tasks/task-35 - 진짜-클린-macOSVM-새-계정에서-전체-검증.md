---
id: TASK-35
title: 진짜 클린 macOS(VM/새 계정)에서 전체 검증
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - platform
dependencies:
  - TASK-6
  - TASK-20
parent_task_id: TASK-50
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

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — GitHub-hosted 러너는 매 실행마다 완전히 새로 프로비저닝되는 ephemeral VM이라 '진짜 클린 macOS' 요건을 구조적으로 만족. full-cycle 양쪽 아키텍처 모두 성공.
---
<!-- COMMENTS:END -->
