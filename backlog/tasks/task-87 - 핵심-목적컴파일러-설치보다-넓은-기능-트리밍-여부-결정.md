---
id: TASK-87
title: 핵심 목적(컴파일러 설치)보다 넓은 기능 트리밍 여부 결정
status: Done
assignee: []
created_date: '2026-08-28 09:42'
updated_date: '2026-08-28 09:56'
labels:
  - scope
milestone: m-2
dependencies: []
priority: medium
type: chore
ordinal: 87000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이번 세션 감사에서 나온 논점: 전역/로컬 버전 고정과 대화형 선택기는 사실 asdf 버전관리를 감싼 부가기능이지 '컴파일러 설치' 자체는 아님. 사용자가 아직 트리밍 여부를 결정 안 함(2026-08-28 논의) — 결정만 나면 실제 작업량은 상당함(00_select.sh 스코프 프롬프트, 06_set_globals.sh 분기, lib.sh read_scope 등 제거/단순화). 지금은 결정 대기 상태로만 기록.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 사용자가 트리밍 여부(유지/축소)를 결정한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:56
---
사용자 결정(2026-08-28): 유지. 전역/로컬 버전 고정과 대화형 선택기 모두 그대로 둔다 — 코드 변경 없음.
---
<!-- COMMENTS:END -->
