---
id: TASK-8
title: Node.js 신규 버전 실제 설치-검증-제거 전체 라이프사이클
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - runtime
dependencies: []
parent_task_id: TASK-43
priority: medium
ordinal: 8000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
기존에 설치돼 있지 않은 Node.js 버전을 실제로 설치하고, 설치 경로/shim/버전이 일치하는지 확인한 뒤, 다시 제거해서 흔적이 남지 않는지까지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 asdf install nodejs <new-version>이 성공하고 ~/.asdf/installs/nodejs/<version>/이 생긴다
- [ ] #2 ASDF_NODEJS_VERSION 오버라이드로 새 버전이 정확히 실행된다
- [ ] #3 asdf uninstall 후 설치 디렉토리가 사라지고 기존 전역 기본값은 영향받지 않는다
<!-- AC:END -->
