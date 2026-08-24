---
id: TASK-19
title: Homebrew/asdf가 이미 있을 때 부트스트랩 스킵
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - homebrew
dependencies: []
parent_task_id: TASK-45
priority: medium
ordinal: 19000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_bootstrap_asdf.sh가 이미 설치된 Homebrew/asdf를 재설치 시도 없이 감지만 하고 넘어가는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 brew/asdf가 이미 있으면 'found' 로그만 찍히고 설치 명령은 실행되지 않는다
<!-- AC:END -->
