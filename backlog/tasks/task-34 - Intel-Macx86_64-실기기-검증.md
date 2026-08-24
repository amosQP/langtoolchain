---
id: TASK-34
title: Intel Mac(x86_64) 실기기 검증
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - platform
dependencies: []
priority: high
ordinal: 34000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금까지 uname 모킹으로 아키텍처 분기 로직(ensure_brew_on_path, BREW_BIN case문 등)만 리뷰했고, 실제 Intel 하드웨어에서 끝까지 실행해본 적은 없다. /usr/local 접두사 경로가 실제로 맞는지 확인 필요.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 실제 Intel Mac에서 curl 한 줄 설치가 /usr/local 기준으로 끝까지 성공한다
<!-- AC:END -->
