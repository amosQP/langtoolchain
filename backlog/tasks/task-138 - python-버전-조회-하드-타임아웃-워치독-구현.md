---
id: TASK-138
title: python 버전 조회 하드 타임아웃 워치독 구현
status: In Progress
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:12'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-131.2
  - decision-10
priority: medium
type: task
ordinal: 198000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-131.2/decision-10 후속 구현. decision-10에서 timeout(1)/git config/소스 전환 3안을
전부 실측 기각하고, 4번째 안(POSIX sh 백그라운드 job + kill 기반 워치독, lt_run_with_
timeout() 초안)을 권고만 하고 구현은 이 태스크로 미뤄뒀다.

lib.sh의 lt_upstream_latest_version() python 브랜치(git ls-remote 기반)가 멈춘 연결
(DNS/TCP/TLS 핸드셰이크 블랙홀)에서 http.lowSpeedLimit/lowSpeedTime로 못 잡는 문제를
해결한다.
<!-- SECTION:DESCRIPTION:END -->
