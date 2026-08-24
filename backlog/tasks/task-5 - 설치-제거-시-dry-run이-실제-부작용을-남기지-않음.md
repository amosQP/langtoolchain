---
id: TASK-5
title: 설치/제거 시 --dry-run이 실제 부작용을 남기지 않음
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - install
dependencies: []
parent_task_id: TASK-42
priority: medium
ordinal: 5000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
설치와 제거 양쪽 모두, --dry-run으로 반복 실행해도 시스템 상태가 전혀 변하지 않는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 install.sh --dry-run --all --yes를 3회 반복해도 매번 exit 0이고 시스템에 변화가 없다
- [ ] #2 uninstall.sh --dry-run --yes도 동일하게 부작용이 없다
<!-- AC:END -->
