---
id: TASK-119.3
title: 캐싱 및 네트워크 실패 시 .tool-versions 폴백 처리
status: To Do
assignee: []
created_date: '2026-08-30 11:41'
labels: []
dependencies:
  - TASK-119.2
parent_task_id: TASK-119
type: task
ordinal: 147000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
동적 버전 조회가 실패(오프라인, API rate limit, 타임아웃)했을 때 설치 흐름이 멈추지 않도록 기존 .tool-versions 정적 값으로 폴백한다. 반복 실행 시 매번 네트워크 조회하지 않도록 캐싱(예: $HOME 하위 캐시 파일, TTL)도 함께 처리.

관련 기존 패턴: scripts/lib.sh의 retry()(212) — 네트워크 재시도 자체는 이미 있는 패턴이므로 재사용 검토. lt_report(설치 리포트 기록, TASK-107) 위치도 캐시 파일 배치 시 참고.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 네트워크 조회 실패 시 .tool-versions 값으로 자동 폴백되고 설치가 중단되지 않음
- [ ] #2 짧은 시간 내 재실행 시 캐시된 값을 재사용해 불필요한 네트워크 조회를 피함
<!-- AC:END -->
