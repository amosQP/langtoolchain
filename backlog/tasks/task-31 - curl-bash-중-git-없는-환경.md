---
id: TASK-31
title: curl | bash 중 git 없는 환경
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - edge-case
dependencies: []
priority: low
ordinal: 31000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
원격 설치 경로(git clone이 필요한 경우)에서 git 명령이 아예 없을 때, 조용히 실패하지 않고 명확한 에러 메시지를 내는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 git이 없으면 'git is required...' 류의 명확한 메시지와 함께 exit 1로 종료된다
<!-- AC:END -->
