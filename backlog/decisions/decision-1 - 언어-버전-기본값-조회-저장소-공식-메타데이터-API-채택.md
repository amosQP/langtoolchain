---
id: decision-1
title: '언어 버전 기본값 조회: 저장소 공식 메타데이터/API 채택'
date: '2026-09-03 01:11'
status: accepted
---
## Context

현재 `.tool-versions`(저장소 루트)의 정적 값이 언어 버전 기본값의 유일한 소스라
시간이 지나면 자동으로 낡는다(m-12/TASK-118). 이를 동적 기본값 조회로 대체/보강할
방법을 두 방향으로 조사했다:

- TASK-118.1: 언어별 저장소 공식 메타데이터/API(nodejs.org, npm 레지스트리, Adoptium
  API, Gradle 서비스 API, git ls-remote(cpython), Rust 채널 매니페스트, go.dev)
- TASK-118.2: asdf 자체 명령(`asdf latest`, `asdf list all`)

핵심 제약: `scripts/install/00_select.sh:284-288`의 기존 주석 — `ask_version()`이
`asdf list all <plugin>`을 안 쓰는 이유는 00_select.sh가 phase 0(asdf 플러그인이
아직 설치돼 있다는 보장이 전혀 없는 시점)에서 실행되고, `list all`이 네트워크 호출
때문에 느릴 수 있기 때문이다.

## Decision

**저장소/언어 공식 메타데이터 소스(TASK-118.1 방식)를 채택한다. asdf 자체 명령
(TASK-118.2 방식)은 채택하지 않는다.**

이유:

1. **phase 0 제약을 "우회"가 아니라 애초에 회피한다.** 118.1의 모든 소스(curl
   기반 HTTP API 6개 + git ls-remote 1개)는 asdf도, 해당 언어의 asdf 플러그인도
   전혀 필요로 하지 않는다. 반면 118.2의 `asdf latest`/`asdf list all`은 실측
   결과 플러그인이 미설치 상태면 즉시 에러난다 — 이는 00_select.sh:284-288이
   이미 지적한 문제 그대로이며, 이번 조사로도 우회 방법을 찾지 못했다(phase 2
   이후로 fetch 시점을 옮기는 방안을 검토했으나, 그 세션의 메뉴에는 반영되지
   않고 오직 "다음 실행"에만 도움이 되어 이 마일스톤의 목표—설치 시점에 최신값을
   제안—를 달성하지 못하며, phase 간 상태 전달 구조를 새로 만들어야 해서 이
   마일스톤 범위를 벗어난다).
2. **7개 언어 전 커버리지가 실측으로 확인됨.** 118.1: 7개 전부 확인. 118.2:
   nodejs/pnpm/rust/golang은 되지만 java/gradle은 기본 쿼리로 실패하고 별도 쿼리
   튜닝이 필요하며, python은 "3.14.7t"(free-threaded 빌드)처럼 이 저장소의 기존
   관례(순수 X.Y.Z)와 다른 값을 반환하는 함정이 실측으로 확인됨.
3. **인증/rate limit 부담이 없거나 낮다.** 118.1의 7개 소스 전부 언어 공식 API/
   배포 인덱스를 직접 쓰므로 GitHub API의 시간당 60회(비인증) 제한과 무관하다.
   GitHub Releases API는 공식 JSON 인덱스가 없는 도구(TASK-121의 uv/poetry 같은
   동반 도구)에만 보조로 쓴다 — 개인 macOS 툴이 세션당 1~2회 실행되는 사용
   패턴에서는 이마저도 문제 되지 않는다고 판단.
4. **응답 속도가 충분히 빠르다.** 118.1 소스 전부 1초 미만(대부분 0.1~0.6s) —
   118.2와 비교해도 밀리지 않으면서 위 세 가지 이점을 함께 얻는다.
5. **실패 시 폴백이 단순하다.** `curl -fsS ... || return 1` / `git ls-remote ... ||
   return 1` 패턴 하나로 모든 실패 케이스(오프라인, rate limit, 타임아웃, 파싱
   실패)를 동일하게 처리할 수 있다. TASK-119.3에서 이 위에 캐싱 + `.tool-versions`
   폴백을 얹는다.

언어별 채택 소스(TASK-119.1 구현 시 그대로 사용):

| 언어/도구 | 소스 | 비고 |
|---|---|---|
| nodejs | (조회 없음) `lts` 그대로 통과 | asdf-nodejs가 install 시점에 직접 해석 - 이미 항상 최신 |
| pnpm | registry.npmjs.org/pnpm/latest | `version` 필드 |
| java(temurin) | api.adoptium.net (2단계: available_releases → assets/latest) | `semver` 필드가 asdf-java 포맷과 그대로 일치 |
| gradle | services.gradle.org/versions/current | `version` 필드, 가장 단순 |
| python | git ls-remote --tags cpython + 정규식 필터 + 숫자 정렬 | 공식 JSON 인덱스 없음(python.org API의 서버측 정렬이 실측상 기대대로 안 됨) |
| rust | static.rust-lang.org/dist/channel-rust-stable.toml | `[pkg.rust]` 섹션의 `version` |
| golang | go.dev/dl/?mode=json | 배열 첫 항목 |

## Consequences

- lib.sh에 새 헬퍼(`lt_upstream_latest_version` 등, TASK-119.1)가 asdf/플러그인
  상태와 완전히 독립적으로 동작 — 00_select.sh의 phase 0에서 바로 호출 가능해
  fetch 시점을 다른 phase로 옮기는 구조 변경이 불필요해진다(TASK-119.2가 더
  단순해짐).
- 7개 언어 소스가 전부 다른 API 형태(JSON 필드명, TOML, git 태그)라 언어별 파싱
  코드가 각각 필요함 — asdf 명령 하나로 통일했다면 없었을 유지보수 비용이지만,
  POSIX sh + grep/sed/awk만으로 전부 구현 가능함을 확인했으므로(jq/python 등
  이 저장소가 전제하지 않는 도구 불필요) 감내 가능한 트레이드오프로 판단.
- java 소스는 macOS 전용이라는 이 저장소의 전제(os=mac 고정, uname -m 기반 arch
  매핑)에 의존한다 — 범용 크로스플랫폼 도구였다면 재검토가 필요했겠지만, 이
  저장소는 README에 명시된 대로 macOS 전용 개인 툴링이므로 문제 없다고 판단.
- 네트워크 실패 시 폴백(.tool-versions 정적값)과 캐싱은 TASK-119.3에서 별도
  구현한다 — 이 결정 자체는 "정상 조회가 가능할 때 어디서 가져올지"만 다룬다.
