---
id: TASK-131
title: 버전 조회 네트워크 타임아웃 일관성 확보
status: Done
assignee: []
created_date: '2026-09-03 11:07'
updated_date: '2026-09-03 11:38'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-119
  - TASK-117.2
priority: medium
type: task
ordinal: 185000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: m-12에서 추가된 버전 조회 네트워크 호출들이 타임아웃 처리 방식이
일관되지 않는다.

1) scripts/install/01_bootstrap_asdf.sh의 fetch_verified_homebrew_installer()가 쓰는
   curl -fsSL -o "$dest" "$HOMEBREW_INSTALL_URL"에는 --max-time이 없다 — 같은 diff에서
   추가된 다른 curl 호출들은 전부 --max-time "$LT_VERSION_FETCH_TIMEOUT"을 쓰는 것과
   대조적. 연결이 끊긴 채(captive portal, dead proxy 등) 멈추면 무한 대기 가능하고,
   이를 감싸는 retry 3 5도 첫 시도가 안 끝나면 재시도 기회조차 없다.

2) lib.sh의 lt_upstream_latest_version() python 브랜치는
   git -c http.lowSpeedLimit=... -c http.lowSpeedTime="$LT_VERSION_FETCH_TIMEOUT"
   ls-remote를 쓰는데, 이건 "이미 시작된 느린 전송"만 감지하고 "멈춘 연결"(DNS/TCP/TLS
   핸드셰이크 단계에서 블랙홀)엔 무력하다. 00_select.sh에서 동기 호출이라 이 경로가 걸리면
   문서화된 LT_VERSION_FETCH_TIMEOUT(기본 5초)보다 훨씬 오래 인터랙티브 설치가 멈출 수 있다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-131.1: scripts/install/01_bootstrap_asdf.sh의 fetch_verified_homebrew_installer() curl에 --max-time "$LT_VERSION_FETCH_TIMEOUT" 추가 - 같은 파일 다른 curl 호출들과 통일. spec/bootstrap_asdf_spec.sh에 정적 검증 테스트 추가(동적 Mock 테스트는 $0 기반 self-location과 소싱 방식이 근본 충돌해 불가능함을 확인, spec 코멘트로 문서화). shellspec 전체 스위트 166 examples 0 failures. TASK-131.2: lib.sh의 python 버전 조회(git ls-remote) 하드 타임아웃 전환을 위해 제시된 3안(timeout 커맨드/git config/소스 전환) 전부 실측 기각 - decision-8에 근거 기록. 채택 가능한 4번째 안(POSIX sh 워치독)은 권고만 하고 구현은 보류(TASK-131.2 스코프인 조사+결정 기록을 넘는 프로덕션 코드 변경이라 후속 태스크로 분리 필요). 따라서 이번 태스크로 lib.sh의 python 브랜치는 코드 변경 없이 남음 - 알려진 한계로 decision-8에 명시됨.
<!-- SECTION:FINAL_SUMMARY:END -->
