---
id: TASK-119
title: 선택된 기본값 조회 방법 구현
status: To Do
assignee: []
created_date: '2026-08-30 11:40'
labels: []
milestone: m-12
dependencies:
  - TASK-118
type: task
ordinal: 141000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Story 1(조사)의 결론에 따라 채택된 방법을 실제 코드에 구현한다.

대상 파일:
- scripts/lib.sh — 새 버전 조회 헬퍼 추가 지점 (binary_for_plugin()/lt_companion_for_plugin() 스타일, lib.sh:542-572 참고)
- scripts/install/00_select.sh:282-298 ask_version(), :368-393 lt_offer_language() — 기본값 제안을 정적 .tool-versions 대신(또는 함께) 동적 값으로 교체하는 실제 통합 지점
- .tool-versions — 조사 결과 캐싱/폴백 값으로 여전히 쓰일 수 있음

주의: ask_version()의 기존 주석(00_select.sh:284-288)이 지적한 phase-0 타이밍 문제(asdf/플러그인 미설치, 네트워크 지연)를 그대로 두고 구현하면 기존에 의도적으로 피한 문제를 재도입하게 됨 — Story 1 조사 결론에 따라 fetch 시점을 재배치하거나 캐싱으로 우회해야 함.
<!-- SECTION:DESCRIPTION:END -->
