---
id: TASK-127.1
title: phase 재배치 여부 결정 (plugin 설치를 selection 이전으로 당길지)
status: Done
assignee: []
created_date: '2026-09-03 01:17'
updated_date: '2026-09-05 04:41'
labels: []
dependencies: []
references:
  - decision-15
parent_task_id: TASK-127
type: task
ordinal: 171000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-118.3(m-12)의 채택안이 asdf 명령 기반(asdf list-all)이면 plugin 설치가 phase 0보다
먼저 필요 -- 현재 phase 순서(0:select -> 1:bootstrap asdf -> 2:install plugins)를 재배치할지,
아니면 phase 0 안에서 필요한 plugin만 미리 add하는 국소 변경으로 끝낼지 결정한다. 채택안이
저장소 메타데이터 기반이면 이 태스크는 "재배치 불필요"로 빠르게 종료하고 근거를 남긴다.
backlog decision으로 최종 판단과 근거를 기록한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
언어 공식 소스(lt_upstream_latest_version(), scripts/lib.sh) 전체 브랜치를 실제 확인한 결과 asdf/플러그인에 전혀 의존하지 않음(decision-4가 이미 이 방식을 채택한 이유이기도 함) — phase 재배치 불필요로 결정(decision-15). rust만 목록 조회용 소스가 별도 필요, TASK-128로 위임. decision-12의 'asdf가 못 따라잡을 수 있음' 갭은 이 결정으로 안 닫힘 - TASK-128/129에서 재검토 필요.
<!-- SECTION:FINAL_SUMMARY:END -->
