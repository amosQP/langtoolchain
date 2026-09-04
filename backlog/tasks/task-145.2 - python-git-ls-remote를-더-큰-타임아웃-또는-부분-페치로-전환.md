---
id: TASK-145.2
title: python git ls-remote를 더 큰 타임아웃 또는 부분 페치로 전환
status: To Do
assignee: []
created_date: '2026-09-04 08:56'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 214000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/lib.sh의 lt_upstream_latest_version() python 브랜치가 cpython 전체 태그(1000개+)
를 git ls-remote --tags --refs로 나열하는데 같은 5초 예산을 씀 — 정상 상황에서도 자주
초과해서 lt_run_with_timeout()이 죽이고 조용히 정적 기본값으로 폴백한다(기능이 사실상
안 켜짐). 더 큰 타임아웃을 주거나, git ls-remote에 refs 필터(예: v3.14.*)를 걸어 응답
크기를 줄이는 방법을 검토한다.
<!-- SECTION:DESCRIPTION:END -->
