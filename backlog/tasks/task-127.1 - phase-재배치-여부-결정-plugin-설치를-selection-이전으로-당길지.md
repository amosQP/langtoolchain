---
id: TASK-127.1
title: phase 재배치 여부 결정 (plugin 설치를 selection 이전으로 당길지)
status: To Do
assignee: []
created_date: '2026-09-03 01:17'
labels: []
dependencies: []
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
