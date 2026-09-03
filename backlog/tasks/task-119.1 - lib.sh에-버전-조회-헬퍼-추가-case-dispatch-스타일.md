---
id: TASK-119.1
title: lib.sh에 버전 조회 헬퍼 추가 (case-dispatch 스타일)
status: To Do
assignee: []
created_date: '2026-08-30 11:41'
labels: []
dependencies: []
parent_task_id: TASK-119
type: task
ordinal: 145000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Story 1(TASK-118.3) 채택안에 따라 scripts/lib.sh에 언어별 최신/기본 버전 조회 헬퍼를 추가한다 (예: lt_upstream_latest_version <plugin>).

기존 코드 스타일 준수: lib.sh:542-572 binary_for_plugin()/lt_companion_for_plugin()이 연관 배열 대신 언어별 case 분기를 쓰는 이유는 bash 3.2/POSIX sh 호환 유지 때문(TASK-71/72 POSIX 전환 정책과 동일 맥락) — 새 헬퍼도 이 패턴을 따른다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 scripts/lib.sh에 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 전부를 처리하는 버전 조회 헬퍼 함수가 추가됨
- [ ] #2 shellcheck 통과 (POSIX sh 준수)
<!-- AC:END -->
