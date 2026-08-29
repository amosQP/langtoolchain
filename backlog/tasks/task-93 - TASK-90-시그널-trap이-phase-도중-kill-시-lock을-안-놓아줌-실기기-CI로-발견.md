---
id: TASK-93
title: TASK-90 시그널 trap이 phase 도중 kill 시 lock을 안 놓아줌 (실기기 CI로 발견)
status: To Do
assignee: []
created_date: '2026-08-28 14:17'
updated_date: '2026-08-28 14:17'
labels:
  - bug
  - shell
milestone: m-2
dependencies: []
priority: high
type: bug
ordinal: 93000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
실제 e2e-verify.yml CI 실행(run 33162354973)에서 발견: kill mid-install then re-run(TASK-32) 잡이 'Another langtoolchain install/uninstall (pid N) appears to be running'로 실패. 원인: main.sh가 phase를 'sh "$SCRIPT_DIR/$phase"'로 동기 실행 중일 때 SIGTERM을 받으면, POSIX 셸은 foreground 명령이 자연히 끝날 때까지 trap 실행을 미룬다(wait()과 달리 일반 blocking 명령 대기는 시그널로 즉시 인터럽트되지 않음). 그래서 05_install_runtimes.sh가 java/python을 계속 컴파일하는 동안 lock이 안 풀린 채로 남아있었고, 곧바로 이어진 재실행이 그 lock에 막혔다. 수정: lib.sh에 run_phase() 추가 — phase를 백그라운드+wait로 실행(POSIX가 trap에 의해 wait이 즉시 인터럽트됨을 보장), handle_interrupt()가 LT_CHILD_PID를 먼저 kill한 뒤 종료. install/uninstall main.sh 둘 다 적용. 스코프: 직계 자식만 kill(더 깊은 손자 프로세스, 예: asdf가 띄운 컴파일러는 안 건드림 — 프로세스 그룹 전체를 죽이면 무관한 프로세스까지 잘못 죽일 위험이 있어 의도적으로 범위를 좁힘, 문서화됨). 로컬에서 sleep 30 자식으로 재현: 수정 전엔 30초 내내 안 죽음(원래도 이 정도로 느린 시나리오를 시험한 적 없었음), 수정 후 SIGTERM 즉시(0초) lock 해제 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 phase 실행 도중 SIGTERM을 받으면 즉시(자식이 끝날 때까지 기다리지 않고) lock을 해제한다
- [x] #2 로컬 재현 테스트로 확인
- [ ] #3 실기기 CI(e2e-verify.yml)의 kill mid-install then re-run 잡이 통과한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 14:17
---
run_phase()로 백그라운드+wait 패턴 적용, handle_interrupt()가 LT_CHILD_PID를 먼저 kill. shellcheck -s sh/dash -n 클린, shellspec 99/99(bash+dash) 통과. 로컬 재현: sleep 30을 자식으로 백그라운드+wait 후 SIGTERM → 이전엔 30초 내내 안 죽었을 걸로 예상되는 시나리오가 수정 후 0초만에 종료+lock 해제 확인. AC #3(실기기 CI)은 푸시 후 별도 확인.
---
<!-- COMMENTS:END -->
