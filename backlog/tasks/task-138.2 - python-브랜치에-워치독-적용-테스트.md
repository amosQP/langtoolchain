---
id: TASK-138.2
title: python 브랜치에 워치독 적용 + 테스트
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 22:14'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
lt_upstream_latest_version()의 python 브랜치(git ls-remote)를 lt_run_with_timeout()으로 감쌈. 구현 중 발견한 이슈: 단일-PID kill만으로는 <cmd>가 낳은 자식(예: git-remote-https)이 orphan으로 남아 호출자의 $(...)가 파이프 EOF를 못 받아 계속 멈춤 - shellspec Mock git으로 실측 재현. 프로세스 그룹 kill(set -m + kill -TERM -PID)은 bash에서만 되고 dash에서는 안 됨을 직접 검증 후 기각, 대신 stdout/stderr을 임시 파일로 캡처(파일은 다른 프로세스가 열어놔도 읽기가 막히지 않음)하는 방식으로 lt_run_with_timeout()을 보강. spec/lib_spec.sh에 git이 절대 응답하지 않는 시나리오(Mock+sleep, 실네트워크 미사용) 테스트 추가. 전체 스위트(175 examples) bash/dash 양쪽 재실행 0 failures, shellcheck -s sh/dash -n 신규 경고 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
