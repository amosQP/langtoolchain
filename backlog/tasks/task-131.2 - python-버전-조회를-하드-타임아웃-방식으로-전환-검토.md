---
id: TASK-131.2
title: python 버전 조회를 하드 타임아웃 방식으로 전환 검토
status: To Do
assignee: []
created_date: '2026-09-03 11:08'
labels: []
dependencies: []
parent_task_id: TASK-131
type: task
ordinal: 187000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lib.sh의 lt_upstream_latest_version() python 브랜치(git ls-remote 기반)를 http.lowSpeedLimit/
lowSpeedTime 대신 하드 wall-clock 타임아웃으로 바꾸는 방법을 조사한다: (a) timeout 커맨드로
git ls-remote 전체를 감싸기(POSIX sh에는 timeout(1)이 기본 없을 수 있어 가용성 확인 필요),
(b) git config http.postBuffer/connectTimeout류 다른 옵션 조합, (c) python 버전 조회 자체를
git ls-remote 대신 다른 소스(예: PyPI/GitHub API)로 바꿔서 curl --max-time을 재사용하는 근본적
전환. 셋 중 채택안을 backlog decision으로 기록.
<!-- SECTION:DESCRIPTION:END -->
