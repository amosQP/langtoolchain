---
id: decision-15
title: phase 재배치 불필요 — 언어 공식 소스는 asdf 없이도 phase 0에서 조회 가능
date: '2026-09-05'
status: accepted
---
## Context

m-15(TASK-127)는 "실제 설치 가능한 버전 목록"을 phase 0(00_select.sh, 언어/버전 선택)
시점에 조회할 수 있게 만드는 게 목표다. 기존 코드 주석(00_select.sh)은 "asdf list all
같은 진짜 목록 조회는 phase 0에서 못 쓴다 — asdf 부트스트랩(phase 1)/플러그인 설치
(phase 2)가 아직 안 끝나서"라고 명시하고 있었다. 이게 사실이면 phase 0을 phase 1/2
이후로 재배치해야 하는지 검토가 필요했다.

## Decision

**phase 순서를 재배치하지 않는다.** 현재 순서(0: 선택 → 1: Homebrew/asdf 부트스트랩 →
2: 플러그인 설치 → ...)를 그대로 유지한다.

## Consequences

- decision-4(m-12/TASK-118.3)가 이미 "asdf 명령 기반이 아니라 언어 공식 메타데이터/API
  기반"을 채택했고, `scripts/lib.sh`의 `lt_upstream_latest_version()`을 실제로 확인한
  결과 모든 언어 브랜치(nodejs/pnpm/gradle/golang/rust/python/java/uv)가 `curl`이나
  `git ls-remote`만 쓰고 asdf/플러그인에 전혀 의존하지 않는다 — phase 0 시점 제약이
  애초에 적용되지 않는다. asdf list all 기반이었다면 재배치가 필요했겠지만, 이 저장소는
  그 경로를 안 쓴다.
- 목록(전체) 조회도 같은 소스로 가능한지 확인: golang(`go.dev/dl/?mode=json`)은 이미
  전체 배열을 반환, python(`git ls-remote --tags`)도 이미 전체 태그 히스토리를 받아서
  현재는 최댓값만 추출하는 것뿐, gradle/pnpm/uv는 "전체 버전" 조회용 자매 엔드포인트가
  있음, java/Adoptium은 여러 LTS major를 나열 가능. **rust만 예외** — 지금 쓰는
  `channel-rust-stable.toml` 소스는 최신 버전 하나만 주므로 목록 조회엔 다른 소스가
  필요하다. 이건 TASK-128로 위임한다(이 태스크는 아키텍처 결정까지만).
- **닫히지 않는 갭**: decision-12(TASK-150)가 이미 지적했듯, 언어 공식 소스가 asdf
  플러그인보다 앞서갈 수 있다는 문제는 이 결정만으로는 완전히 해소되지 않는다 —
  TASK-128(목록 조회)/TASK-129(그 목록 기반 선택 UI)가 "asdf가 실제로 설치 가능한
  것만 선택지에 올린다"는 걸 보장하지 않는 한, 언어 공식 소스의 최신 버전이 여전히
  asdf 플러그인이 아직 못 따라잡은 것일 수 있다. TASK-128/129 설계 시 이 갭을 어떻게
  다룰지(예: asdf list all과 교차 검증) 반드시 재검토해야 한다.
