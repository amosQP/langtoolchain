---
id: TASK-85
title: CI(e2e-verify.yml)를 PR/push에도 자동 실행
status: To Do
assignee: []
created_date: '2026-08-28 09:42'
labels:
  - ci
milestone: m-2
dependencies: []
priority: low
type: chore
ordinal: 85000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
현재 e2e-verify.yml은 workflow_dispatch(수동)만 지원. 자동 회귀 검증을 원하면 push/PR 트리거 추가 필요 — 다만 이 워크플로는 실기기에 실제로 Homebrew/asdf를 설치/제거하는 느린 잡이라(수 분~수십 분) 매 커밋마다 돌리는 게 맞는지는 별도 판단 필요.
<!-- SECTION:DESCRIPTION:END -->
