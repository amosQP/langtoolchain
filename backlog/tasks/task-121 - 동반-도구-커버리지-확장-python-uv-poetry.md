---
id: TASK-121
title: '동반 도구 커버리지 확장 (python: uv/poetry)'
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:29'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3개 하위 태스크(121.1/121.2/121.3) 모두 완료. python 동반 도구로 uv 채택
(decision-2, poetry/둘다지원 기각 - asdf 플러그인 성숙도 동등하나 단일 바이너리
설치 방식이 이 저장소의 asdf-플러그인-하나로-설치 모델과 더 맞고, 생태계 채택
추세도 앞섬). lt_companion_for_plugin()에 python->uv 매핑 추가, .tool-versions에
기본 버전 추가, lt_upstream_latest_version()에 uv 케이스(GitHub Releases API)
추가로 TASK-119 인프라를 그대로 재사용 - 별도 통합 코드 없이 나머지 7개 언어와
동일한 캐시/폴백 경로를 탐.

전체 shellspec 스위트 151 examples 0 failures. 실 $HOME 캐시파일 미접촉 확인.
<!-- SECTION:FINAL_SUMMARY:END -->
