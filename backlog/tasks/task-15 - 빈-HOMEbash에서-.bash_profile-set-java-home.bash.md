---
id: TASK-15
title: 빈 $HOME(bash)에서 .bash_profile + set-java-home.bash
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - shell
dependencies: []
parent_task_id: TASK-44
priority: medium
ordinal: 15000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SHELL=/bin/bash일 때 rc 파일로 .bash_profile이 선택되고, Java 훅도 bash용 파일(set-java-home.bash)로 기록되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 .bash_profile이 생성되고 set-java-home.bash 줄이 포함된다
<!-- AC:END -->
