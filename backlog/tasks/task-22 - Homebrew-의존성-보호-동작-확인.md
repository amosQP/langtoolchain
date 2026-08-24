---
id: TASK-22
title: Homebrew 의존성 보호 동작 확인
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - uninstall
dependencies: []
priority: medium
ordinal: 22000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
제거 대상 formula를 다른 설치된 도구가 의존하고 있으면 brew가 거부하고, 아무도 안 쓰는 formula만 실제로 제거되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 다른 도구가 쓰는 openssl/readline/sqlite3/xz/tcl-tk 등은 제거가 거부된다
- [ ] #2 아무도 안 쓰는 formula(예: zlib)는 정상적으로 제거된다
<!-- AC:END -->
