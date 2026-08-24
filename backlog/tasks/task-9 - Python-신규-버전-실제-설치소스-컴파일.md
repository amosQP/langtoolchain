---
id: TASK-9
title: Python 신규 버전 실제 설치(소스 컴파일)
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - runtime
dependencies: []
parent_task_id: TASK-43
priority: high
ordinal: 9000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Python은 asdf-python이 기본적으로 소스에서 컴파일한다. openssl/readline/sqlite3/zlib 빌드 플래그(LDFLAGS/CPPFLAGS/PKG_CONFIG_PATH)로 컴파일이 끝까지 성공하는지 검증. 이번 세션 내내 Node.js만 신규 설치 테스트를 했고 Python은 한 번도 처음부터 실제로 설치해보지 않았다 — 가장 느리고 실패 가능성이 높은 언어라 별도 항목으로 분리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 asdf install python <new-version>이 빌드 에러 없이 끝까지 완료된다
- [ ] #2 설치된 python이 ssl/sqlite3 모듈을 정상적으로 import할 수 있다
<!-- AC:END -->
