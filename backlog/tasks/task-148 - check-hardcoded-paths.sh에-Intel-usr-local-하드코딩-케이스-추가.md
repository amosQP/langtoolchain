---
id: TASK-148
title: check-hardcoded-paths.sh에 Intel(/usr/local) 하드코딩 케이스 추가
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-125
  - TASK-61
priority: low
type: task
ordinal: 221000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: check-hardcoded-paths.sh(TASK-125)가 Homebrew prefix 하드코딩을
검사할 때 Apple Silicon 경로(/opt/homebrew)만 grep하고 Intel 경로(/usr/local)는 검사
안 한다. lt_homebrew_prefix()(scripts/lib.sh)는 두 경로를 대칭적으로 다루는데, 이 lint
도구는 그 절반만 커버한다 — TASK-61(Intel sqlite PATH 버그)과 정확히 반대되는 케이스가
재발해도 이 lint를 통과한다. /usr/local 하드코딩 패턴도 검사 대상에 추가.
<!-- SECTION:DESCRIPTION:END -->
