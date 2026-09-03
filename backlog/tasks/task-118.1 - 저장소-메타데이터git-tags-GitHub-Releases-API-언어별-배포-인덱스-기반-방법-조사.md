---
id: TASK-118.1
title: 저장소 메타데이터(git tags/GitHub Releases API/언어별 배포 인덱스) 기반 방법 조사
status: Done
assignee: []
created_date: '2026-08-30 11:40'
updated_date: '2026-09-03 01:10'
labels: []
dependencies: []
parent_task_id: TASK-118
type: spike
ordinal: 142000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
각 언어의 upstream 저장소/배포처에서 최신 안정 버전을 알아내는 방법을 조사한다. 예시 후보(조사하며 확정):
- git ls-remote --tags <repo-url> — 태그 목록을 네트워크 클론 없이 조회 (예: nodejs/node, python/cpython, rust-lang/rust, golang/go)
- GitHub Releases API (api.github.com/repos/<owner>/<repo>/releases/latest) — rate limit(비인증 시 시간당 60회) 고려 필요, 이 저장소가 CI 없이 로컬 실행되는 curl|sh 설치 스크립트라는 점에서 rate limit이 실사용에 문제될지 평가
- 언어별 공식 배포 인덱스: 예 nodejs.org/dist/index.json (LTS 플래그 포함), 각 언어마다 존재 여부/형식이 다름 — 이 저장소가 다루는 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 각각에 대해 존재 여부 확인

각 방법에 대해: 언어별 커버리지(7개 전부 지원 가능한지), 인증 필요 여부, 응답 속도, 실패 시 폴백 난이도를 정리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 nodejs/pnpm/java/gradle/python/rust/golang 7개 언어 각각에 대해 최소 1개 이상의 저장소 메타데이터 기반 방법이 확인됨
- [x] #2 각 방법의 인증 요구사항·rate limit·응답 속도가 기록됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-09-03 실측 (이 개발 머신에서 curl/git ls-remote로 직접 조회, 네트워크 실사용):

언어별 저장소 메타데이터 기반 소스(7개 전부 확인됨):

- nodejs: nodejs.org/dist/index.json (공식 배포 인덱스, lts 필드 포함). 인증 불필요, 응답 ~0.1-0.6s.
  단, 현재 .tool-versions는 이미 "lts"라는 alias를 값으로 씀 - asdf-nodejs 플러그인이
  `asdf install nodejs lts` 시점에 직접 해석하므로 이 값 자체가 이미 "항상 최신"이라
  네트워크 조회 없이도 동적임 (118.3 결정에 반영).
- pnpm: registry.npmjs.org/pnpm/latest (npm 레지스트리, 공식 배포처). "version" 필드.
  인증 불필요, ~0.1s.
- java(temurin): api.adoptium.net 공식 API. 2단계: (1) /v3/info/available_releases ->
  most_recent_lts 필드로 현재 LTS major 확인 (2026-09-03 기준 25) (2)
  /v3/assets/latest/{major}/hotspot?vendor=eclipse&os=mac&image_type=jdk&architecture=<arch>
  -> semver 필드가 asdf-java 플러그인의 버전 문자열 포맷과 정확히 일치
  (예: "25.0.4+101.0.LTS", asdf list all java의 "temurin-25.0.4+101.0.LTS"와 동일 형식).
  인증 불필요, 각 호출 ~0.3-0.6s. os/architecture 파라미터가 필요 - 이 저장소는 macOS
  전용이므로 os=mac 고정, architecture는 uname -m 매핑(arm64->aarch64, 그외->x64)으로 결정.
- gradle: services.gradle.org/versions/current (Gradle 공식 API). "version" 필드 단일값,
  가장 단순함. 인증 불필요, ~0.1s.
- python: 공식 JSON 배포 인덱스 없음 (python.org/api/v2/downloads/release/는 정렬/필터
  파라미터가 서버측에서 기대대로 동작하지 않음 - ordering=-release_date를 줘도 오래된
  순 그대로 반환됨, 실측 확인). 대안으로 git ls-remote --tags cpython 사용 - 태그가
  vX.Y.Z(final)/vX.Y.ZaN/bN/rcN(prerelease) 혼재하므로 정규식(^v?[0-9]+\.[0-9]+\.[0-9]+$)
  필터 + 필드별 숫자 정렬(sort -t. -k1,1n -k2,2n -k3,3n, macOS BSD sort는 -V 미지원이라
  이 방식 사용) 필요. 인증/rate limit 없음(git 프로토콜), ~0.5-0.6s.
- rust: static.rust-lang.org/dist/channel-rust-stable.toml (공식 릴리스 채널 매니페스트).
  [pkg.rust] 섹션의 version 필드(다른 패키지들의 버전과 섞여 있어 섹션 지정 필요).
  인증 불필요, ~0.1s.
- golang: go.dev/dl/?mode=json (공식 배포 인덱스). 배열 첫 항목이 최신 stable.
  인증 불필요, ~0.1-0.6s.

인증/rate limit 총평: 위 7개 소스 전부 GitHub Releases API를 안 씀 - 각 언어 공식
배포처/API를 직접 쓰므로 GitHub의 시간당 60회(비인증) rate limit과 무관. GitHub
Releases API는 공식 JSON 인덱스가 없는 도구(m-12 companion 후보 uv/poetry)에만
보조로 씀 - 개인 macOS 툴이 세션당 1~2회 curl|sh로 실행되는 사용 패턴에서는 60/h도
충분하다고 판단(실사용 트래픽이 이 한도에 닿을 시나리오가 없음).

응답 속도: 전 소스 공통 1초 미만(대부분 0.1-0.6s). 프롬프트 응답 대기 중(사용자가
"이 언어 설치할까요?"에 답한 직후) 발생시키면 체감 지연 거의 없음.

실패 시 폴백 난이도: 전부 단순 curl -fsS(비-2xx/네트워크 오류시 자동 실패) 또는
git ls-remote 실패로 감지 가능 - 특별한 파싱 없이 "$(cmd) || return 1" 패턴으로
바로 폴백 트리거 가능 (TASK-118.3/119 참고).
<!-- SECTION:NOTES:END -->
