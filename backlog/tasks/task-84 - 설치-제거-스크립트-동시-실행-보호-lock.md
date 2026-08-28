---
id: TASK-84
title: 설치/제거 스크립트 동시 실행 보호 (lock)
status: Done
assignee: []
created_date: '2026-08-28 09:42'
updated_date: '2026-08-28 09:52'
labels:
  - feature
  - shell
milestone: m-2
dependencies: []
priority: high
type: feature
ordinal: 84000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
같은 머신에서 install/main.sh와 uninstall/main.sh(또는 둘 중 하나를 두 번)를 동시에 돌리는 것에 대한 보호가 없어서, asdf/Homebrew 상태를 두 프로세스가 동시에 건드리면 레이스가 날 수 있음. mkdir 기반 원자적 lock(POSIX에서 flock 없이도 안전) + lock 안에 PID 기록 후 kill -0으로 생존 확인해서 죽은 프로세스가 남긴 stale lock은 자동 회수. install/main.sh와 uninstall/main.sh가 시작하자마자(맨 처음) 획득, EXIT trap으로 해제. 두 스크립트가 같은 lock을 공유해서 install↔uninstall 교차 동시 실행도 막음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 동일 lock을 쥔 상태에서 두 번째 install 또는 uninstall 실행 시 명확한 에러로 즉시 종료
- [x] #2 정상 종료/에러 종료 모두 lock이 해제된다 (trap)
- [x] #3 죽은 프로세스가 남긴 stale lock은 자동으로 회수된다
- [x] #4 shellspec 회귀 테스트 추가
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:52
---
lib.sh에 LT_LOCK_DIR(${LT_LOCK_DIR:-$TMPDIR/langtoolchain.lock}, 테스트에서 오버라이드 가능하도록 ASDF_DATA_DIR과 동일 패턴)와 acquire_lock/release_lock 추가. mkdir 원자성으로 lock 획득, 이미 잡혀있으면 pid 파일의 PID를 kill -0으로 생존 확인 후 살아있으면 die(), 죽어있으면 stale lock 자동 회수. install/main.sh·uninstall/main.sh 둘 다 시작 즉시 lib.sh 소스 + acquire_lock + trap release_lock (install 쪽은 기존 TASK-80의 SELECTION_FILE 정리 trap과 하나로 합침 — trap은 마지막 설정만 유효하므로). 실제 프로세스로 검증: 살아있는 PID로 lock 잡아두면 install/uninstall 둘 다(공유 lock) 명확한 에러+exit 1로 즉시 거부, 정상/에러 종료 모두 trap으로 lock 해제 확인. spec/lib_spec.sh에 5개 예제 추가(신규 획득/해제/no-op release/살아있는 프로세스 차단은 실제 서브프로세스로 검증/stale lock 회수), shellspec 78/78(bash+dash) 통과. README(양쪽 언어)에 lock 파일 문서화.
---
<!-- COMMENTS:END -->
