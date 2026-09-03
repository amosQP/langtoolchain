---
id: TASK-118.2
title: 'asdf 자체 제공 명령(asdf latest, list-all) 기반 방법 조사'
status: To Do
assignee: []
created_date: '2026-08-30 11:41'
labels: []
dependencies: []
parent_task_id: TASK-118
type: spike
ordinal: 143000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
asdf 자체가 제공하는 버전 조회 명령(asdf latest <plugin> [version], asdf list all <plugin>)을 이 저장소에서 실제로 쓸 수 있는지 재검토한다.

이미 00_select.sh:284-288에 "phase 0에서 list-all을 쓰지 않은 이유"가 문서화돼 있음 — 이 태스크는 그 판단을 뒤집는 게 아니라, "phase 0가 아닌 다른 시점"이나 "캐싱 결합"으로 asdf 자체 명령을 여전히 활용할 수 있는지 조사한다. 예: 플러그인이 이미 설치된 이후 시점(phase 2 이후)에 한 번 조회해서 다음 실행부터 기본값으로 캐싱하는 방식이 가능한지.

asdf latest는 list-all보다 가벼울 수 있음(단일 최신값만 반환) — 이것이 phase 0 제약을 완화할 수 있는지도 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 asdf latest / asdf list all 각각의 실행 비용(네트워크 호출 여부, 소요 시간 실측)이 기록됨
- [ ] #2 phase 0 제약(00_select.sh:284-288)을 우회할 수 있는 실행 시점 또는 캐싱 조합이 최소 1개 이상 제안됨
<!-- AC:END -->
