---
id: TASK-138.2
title: python 브랜치에 워치독 적용 + 테스트
status: To Do
assignee: []
created_date: '2026-09-03 12:06'
labels: []
dependencies:
  - TASK-138.1
parent_task_id: TASK-138
type: task
ordinal: 200000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lt_upstream_latest_version()의 python(git ls-remote) 호출을 138.1의 lt_run_with_timeout()
으로 감싼다. spec/lib_spec.sh에 "타임아웃 시 실패 반환(무한 대기 안 함)" 케이스를 mock으로
추가(예: 절대 안 끝나는 명령을 sleep으로 흉내내고 워치독이 실제로 kill하는지 확인 — 실제
네트워크 사용 금지). 전체 shellspec 재실행으로 회귀 없음 확인.
<!-- SECTION:DESCRIPTION:END -->
