---
id: TASK-131
title: 버전 조회 네트워크 타임아웃 일관성 확보
status: To Do
assignee: []
created_date: '2026-09-03 11:07'
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
