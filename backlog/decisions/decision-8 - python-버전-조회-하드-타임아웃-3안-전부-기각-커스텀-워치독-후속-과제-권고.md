---
id: decision-8
title: 'python 버전 조회 하드 타임아웃: 조사한 3안 전부 기각, 커스텀 워치독은 후속 과제로 권고'
date: '2026-09-03 11:36'
status: proposed
---
## Context

TASK-131(/code-review high 발견)이 지적: `scripts/lib.sh`의 `lt_upstream_latest_version()`
python 브랜치(`git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime="$LT_VERSION_FETCH_TIMEOUT"
ls-remote --tags --refs https://github.com/python/cpython.git`)는 "이미 시작된 느린 전송"만
감지하는 `http.lowSpeedLimit`/`http.lowSpeedTime`을 쓴다 - DNS/TCP/TLS 핸드셰이크 단계에서
연결이 블랙홀되면(전송 자체가 시작되지 않으므로) 이 가드가 전혀 작동하지 않아 무한 대기할 수
있다. 00_select.sh에서 동기 호출이라 여기 걸리면 문서화된 LT_VERSION_FETCH_TIMEOUT(기본 5초)
보다 훨씬 오래 인터랙티브 설치가 멈춘다. TASK-131.2가 이 개발 머신에서 실측 조사한 3가지
대안:

1. **`timeout` 커맨드로 `git ls-remote` 전체를 감싸기.** 이 개발 머신에는
   `/opt/homebrew/bin/timeout`, `/opt/homebrew/bin/gtimeout` 둘 다 존재해서 처음엔 되는 것처럼
   보였지만, 이건 이 머신에 Homebrew coreutils가 이미 설치돼 있기 때문일 뿐이다. 이 저장소가
   실제로 타깃하는 환경(01_bootstrap_asdf.sh 헤더 주석: "a fresh Mac with neither pre-installed")
   -- 즉 Homebrew조차 아직 없는 완전히 새 macOS -- 에는 `timeout(1)`도 `gtimeout(1)`도 stock
   macOS/BSD 유저랜드에 없다(GNU coreutils 전용, macOS 기본 미탑재). 00_select.sh의 python 버전
   조회는 phase 0 -- Homebrew 설치 여부조차 보장 안 되는 시점(scripts/install/01_bootstrap_asdf.sh
   가 아직 안 돌았을 수도 있음) -- 에서 호출되므로, "coreutils가 이미 있다"를 전제로 할 수 없다.
   기각.
2. **git config로 다른 timeout류 옵션 조합(`http.postBuffer`, connect-timeout 유사 옵션 등).**
   `man git-config`로 `http.*` 네임스페이스 전수 확인: connect/wall-clock 타임아웃에 해당하는
   옵션이 아예 존재하지 않는다(`http.lowSpeedLimit`/`http.lowSpeedTime`이 유일한 timeout류
   옵션이고, 정확히 지금 문제가 되는 "전송 시작 전" 케이스를 못 잡는 그 옵션이다).
   `core.filesRefLockTimeout`/`core.packedRefsTimeout`/`credentialStore.lockTimeoutMS`/
   `reftable.lockTimeout` 등 다른 `*Timeout` 옵션은 전부 로컬 파일 잠금용이지 네트워크
   연결과 무관. git 자체가 하드 connect-timeout을 제공하지 않는다는 뜻이므로 기각(git config
   조합만으로는 해결 불가능).
3. **python 버전 조회 소스를 git ls-remote 대신 다른 곳(PyPI/GitHub API)으로 바꿔 curl
   --max-time을 재사용.** PyPI는 패키지 인덱스지 CPython 인터프리터 배포처가 아니라 애초에
   해당 없음. GitHub REST API(`api.github.com/repos/python/cpython/tags`)는 curl 기반이라
   `--max-time`을 그대로 쓸 수 있지만, 실측(`curl .../tags?per_page=5`) 결과 반환 순서에
   rc/beta 프리릴리스가 최종 릴리스보다 앞서 섞여 나온다 - 지금 git ls-remote 브랜치가 이미
   처리 중인 것과 동일한 필터링 문제이고, 페이지당 30~100개뿐이라 최신 final 릴리스를 찾으려면
   여러 페이지를 순회해야 할 수 있다(현재는 태그 전체를 한 번의 `ls-remote` 호출로 받아 한 번에
   정렬). 즉 네트워크 호출 지점이 하나에서 여러 개로 늘어나 "멈추는 지점"이 오히려 늘어날 뿐이고,
   decision-4가 이미 "python.org 공식 JSON 인덱스는 서버측 정렬/필터가 기대대로 안 됨"을 이유로
   git ls-remote를 채택한 그 결정을 흔드는 재작업이 필요해진다 - TASK-131의 스코프(타임아웃
   일관성)를 넘어서는 변경. 기각.

## Decision

**제시된 3안 중 채택 가능한 것이 없다.** 대신, 외부 바이너리 의존 없이 이 저장소가 이미 쓰는
POSIX sh 백그라운드 job + `kill` 패턴(예: TASK-93의 lock/signal 처리와 같은 계열)으로 순수
wall-clock 하드 타임아웃 래퍼를 구현하는 안을 **권고안**으로 남긴다:

```sh
# lt_run_with_timeout <seconds> <cmd> [args...] (구현 예시, 미적용)
lt_run_with_timeout() {
  local secs="$1"; shift
  "$@" & local cmd_pid=$!
  ( sleep "$secs"; kill -TERM "$cmd_pid" 2>/dev/null ) & local watchdog_pid=$!
  wait "$cmd_pid" 2>/dev/null; local status=$?
  kill "$watchdog_pid" 2>/dev/null; wait "$watchdog_pid" 2>/dev/null
  return "$status"
}
```

이 안은 TASK-131.2가 조사하도록 지정된 3가지 옵션 어디에도 속하지 않는 4번째 안이라, TASK-131.2
자체의 스코프(조사 + 결정 기록)를 넘어 **구현하지 않았다** - 새 코드 경로를 프로덕션에 추가하는
일이므로 별도 검토/승인 없이 조용히 반영하지 않는다(claude-rails 워크플로: AC 밖 작업은 확인 후
진행). 실제 채택 여부와 구현은 별도 후속 태스크로 분리하는 것을 권고한다.

## Consequences

- lib.sh의 `lt_upstream_latest_version()` python 브랜치는 이 결정 시점 기준 **수정되지 않은
  채로 남는다** - TCP/TLS 핸드셰이크 블랙홀 시나리오에서 여전히 `LT_VERSION_FETCH_TIMEOUT`보다
  오래 멈출 수 있는 알려진 한계가 지속됨. (TASK-131.1의 Homebrew curl 수정과 달리, 이 지점은
  이번 마일스톤에서 코드 변경 없이 종료됨.)
- 후속 구현이 필요하면 새 태스크를 만들어 위 `lt_run_with_timeout()` 초안을
  spec/lib_spec.sh의 retry() 테스트(Mock sleep 패턴)처럼 Mock 기반으로 검증하면서 진행할 것 -
  이 함수 자체가 재사용 가능한 일반 유틸리티라 python 브랜치뿐 아니라 이론상 다른 네트워크
  호출에도 나중에 적용 가능(지금은 curl 쪽은 `--max-time`으로 이미 충분히 커버되므로 git
  ls-remote 지점 하나만 대상).
- `timeout(1)`/`gtimeout(1)`을 이 저장소의 전제 도구 목록에 추가하는 방향은 이 결정으로
  명시적으로 닫힘 - phase 0(Homebrew 설치 보장 전)에서 실행되는 코드가 Homebrew로만 설치
  가능한 GNU coreutils에 의존할 수 없다는 이유가 앞으로도 동일하게 적용됨.
