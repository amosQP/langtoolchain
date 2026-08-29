---
id: TASK-99
title: lib.sh에 동반 도구 매핑 함수 추가
status: To Do
assignee: []
created_date: '2026-08-29 13:41'
labels: []
milestone: m-7
dependencies: []
type: task
ordinal: 114000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
binary_for_plugin()/flag_for_binary()와 같은 패턴으로 lt_companion_for_plugin(plugin) 함수 추가 — nodejs->pnpm, java->gradle, rust/golang은 빈 문자열(동반 도구 없음, cargo/go tool이 이미 번들). 확장 가능한 구조로 설계(새 언어 추가 시 이 함수 case 한 줄만 늘리면 됨).
<!-- SECTION:DESCRIPTION:END -->
