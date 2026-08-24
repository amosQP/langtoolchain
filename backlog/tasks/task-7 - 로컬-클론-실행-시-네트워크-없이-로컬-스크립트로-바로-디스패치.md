---
id: TASK-7
title: 로컬 클론 실행 시 네트워크 없이 로컬 스크립트로 바로 디스패치
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - install
dependencies: []
priority: medium
ordinal: 7000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh가 scripts/install 디렉토리를 옆에서 발견하면 git clone 없이 바로 로컬 스크립트를 실행하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 로컬 클론에서 ./install.sh 실행 시 git clone이 시도되지 않는다
<!-- AC:END -->
