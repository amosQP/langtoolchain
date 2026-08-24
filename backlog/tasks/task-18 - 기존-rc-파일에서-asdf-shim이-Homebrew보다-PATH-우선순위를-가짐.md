---
id: TASK-18
title: 기존 rc 파일에서 asdf shim이 Homebrew보다 PATH 우선순위를 가짐
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - shell
dependencies: []
parent_task_id: TASK-44
priority: medium
ordinal: 18000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
다른 도구가 이미 여러 줄을 채워놓은 실제 사용자 rc 파일에 langtoolchain 설정을 추가했을 때, 새 로그인+인터랙티브 셸에서 asdf shim이 동일 이름의 Homebrew formula보다 우선하는지 확인. 이번 세션에 실기기에서 한 번 수동으로 확인했지만(brew shellenv 순서 버그를 그 자리에서 고침), 반복 실행 가능한 자동 체크로는 아직 없음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 zsh -lic 'command -v node'가 항상 ~/.asdf/shims/node를 가리킨다 (다른 도구가 rc 파일 뒤쪽에 PATH를 추가로 prepend해도)
<!-- AC:END -->
