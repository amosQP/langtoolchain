---
id: TASK-21
title: 아무것도 설치 안 된 상태에서 전체 제거 파이프라인 통과
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - uninstall
dependencies: []
priority: medium
ordinal: 21000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
~/.asdf, rc 파일, ~/.tool-versions 등이 전혀 없는 상태에서 uninstall 전체 파이프라인이 에러 없이 '이미 없음' 처리로 끝까지 통과하는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 모든 phase가 exit 0으로 끝난다
- [ ] #2 에러 메시지 없이 '이미 없음/absent' 류의 로그만 남는다
<!-- AC:END -->
