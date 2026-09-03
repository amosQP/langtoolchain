---
id: TASK-121
title: '동반 도구 커버리지 확장 (python: uv/poetry)'
status: To Do
assignee: []
created_date: '2026-08-30 12:00'
labels: []
milestone: m-12
dependencies: []
type: task
ordinal: 149000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
외부 리뷰(2026-08-30)에서 지적: 현재 lib.sh:566-572 lt_companion_for_plugin()은 nodejs→pnpm, java→gradle만 지원하고, python의 핵심 패키지 관리자(uv/poetry)는 검토조차 안 돼 있음. rust/golang은 표준 도구(cargo/go modules)가 언어에 내장돼 있어 별도 companion이 필요 없다고 판단, python만 실제 갭.

m-12(TASK-118/119)에서 만들 "언어별 기본 버전 동적 조회" 인프라를 그대로 재사용 가능한 자연스러운 연장 — 새 동반 도구를 추가하면 그 도구의 기본 버전도 똑같이 "어디서 가져올지" 문제가 생기므로.
<!-- SECTION:DESCRIPTION:END -->
