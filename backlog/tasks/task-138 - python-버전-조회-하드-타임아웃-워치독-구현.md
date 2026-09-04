---
id: TASK-138
title: python 버전 조회 하드 타임아웃 워치독 구현
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 22:14'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-138.1/138.2 완료. lib.sh에 lt_run_with_timeout(seconds, cmd...) POSIX sh 워치독 헬퍼 추가(백그라운드 job + kill 기반, dash 호환), lt_upstream_latest_version()의 python(git ls-remote) 브랜치에 적용해 decision-10이 지적한 DNS/TCP/TLS 핸드셰이크 블랙홀 무한 대기를 해결. 구현 중 프로세스 그룹 kill(set -m)이 bash에서만 동작하고 dash에서는 백그라운드 job을 별도 그룹으로 만들지 않음을 실측으로 확인해 기각, stdout/stderr을 임시 파일로 캡처하는 방식으로 전환해 orphan 자식 프로세스가 있어도 호출자가 멈추지 않도록 함. spec/lib_spec.sh에 lt_run_with_timeout() 단위 테스트 4건 + python 브랜치 타임아웃 통합 테스트 1건 추가(전부 mock/sleep 기반, 실네트워크 미사용). 전체 shellspec 스위트 175 examples를 bash/dash 양쪽으로 재실행해 0 failures 확인, shellcheck -s sh/dash -n 신규 경고 없음(기존 SC3043 등 베이스라인만). 로컬 task/TASK-138 브랜치에 커밋 2개(TASK-138.1, TASK-138.2)만 존재, push/merge 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
