---
id: TASK-125.2
title: 감지 방식 조사 및 채택안 결정
status: Done
assignee: []
created_date: '2026-09-03 01:14'
updated_date: '2026-09-03 01:18'
labels: []
dependencies:
  - TASK-125.1
references:
  - decision-7
parent_task_id: TASK-125
type: task
ordinal: 163000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-125.1에서 정리한 하드코딩 패턴을 자동 감지할 방식을 조사하고 채택안을 결정한다. 최소 3개 옵션 비교:
1) shellcheck 커스텀 룰/디렉티브 — shellcheck 자체 확장 메커니즘의 한계(임의 문자열 리터럴 금지 룰 작성 난이도) 확인 필요
2) grep 기반 lint 스크립트 (scripts/lib.sh 등에 신규 헬퍼 또는 별도 scripts/lint/ 스크립트) — 구현/유지보수 단순성
3) shellspec 테스트로 소스 파일 내용을 grep해서 검증 — 기존 테스트 인프라 재사용

결정 기준: 오탐률, CI 연결 난이도, 유지보수 비용, 기존 워크플로(shellcheck -s sh, shellspec)와의 정합성.
결정은 backlog decision으로 기록하고 이 태스크에 --ref decision-N으로 연결.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 최소 3개 감지 방식이 비교표로 정리됨
- [x] #2 채택안이 backlog decision으로 기록되고 근거가 명시됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3개 감지 방식(shellcheck 커스텀 룰 / grep 기반 lint 스크립트 / shellspec 테스트)을 비교(decision-7 참고). shellcheck 0.11.0은 custom rule/plugin 메커니즘이 전혀 없어 옵션1 배제. 이 저장소는 CI에 shellspec을 아직 전혀 연결하지 않은 상태(e2e-verify.yml은 실기기 설치/제거 검증 전용)라 옵션3은 CI 연결 비용이 옵션2보다 큼. grep 기반 독립 lint 스크립트(scripts/lint/check-hardcoded-paths.sh, ubuntu-latest 저비용 CI job)를 채택 — decision-7로 기록.
<!-- SECTION:FINAL_SUMMARY:END -->
