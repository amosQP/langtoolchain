---
id: decision-16
title: 버전 목록 캐싱은 별도 파일/함수로 - 기존 단일값 캐시(TASK-119.3)와 분리
date: '2026-09-05'
status: accepted
---
## Context

TASK-119.3(m-12, Done)이 이미 "기본값 1개" 조회 결과를 캐싱하는 인프라를 만들어뒀다:
`LT_VERSION_CACHE_FILE`(기본 `$HOME/.langtoolchain-version-cache`), `LT_VERSION_CACHE_TTL`
(기본 86400초), 트리플파이프(`plugin|||timestamp|||version`) 라인 포맷,
`lt_resolve_default_version()`의 3단계 폴백(캐시 → 실시간 조회 → 정적 기본값). 이미
shellspec으로 검증돼 있고 안정적으로 동작 중이다.

m-15(TASK-128)는 "기본값 1개"가 아니라 "설치 가능한 전체 버전 목록"을 조회해야 하는데,
이 목록 캐싱을 기존 단일값 캐시 인프라를 확장해서 같이 쓸지, 완전히 별도로 둘지 결정이
필요하다.

## Decision

**완전히 별도의 캐시 파일/함수를 쓴다** — 기존 단일값 캐시(`LT_VERSION_CACHE_FILE`,
`lt_cached_version_lookup`, `lt_cache_version`)는 손대지 않는다.

- 새 파일: `LT_VERSION_LIST_CACHE_FILE`(기본 `$HOME/.langtoolchain-version-list-cache`,
  `${VAR:-default}` 오버라이드 패턴 - 기존 관례 그대로)
- 새 TTL: `LT_VERSION_LIST_CACHE_TTL`(기본 86400초 - 기존과 동일 값이지만 별도
  변수로 둬서 나중에 독립적으로 조정 가능하게 함, `LT_VERSION_FETCH_TIMEOUT`/
  `LT_PYTHON_TAGS_TIMEOUT`을 분리해뒀던 기존 관례와 동일한 이유)
- 같은 트리플파이프 라인 포맷을 쓰되 값 필드는 콤마로 조인한 버전 목록
  (`plugin|||timestamp|||v1,v2,v3,...`)
- 새 함수 `lt_cached_version_list_lookup()`/`lt_cache_version_list()` — 기존
  `lt_cached_version_lookup()`/`lt_cache_version()`은 시그니처/동작 그대로 유지

## Consequences

- **왜 확장이 아니라 분리인가**: 기존 단일값 캐시 함수는 이미 TASK-119.3에서 테스트
  통과된 채로 운영 중이다. 하나의 함수가 "단일 값"과 "목록"을 둘 다 다루게 확장하면
  로직이 복잡해지고 기존 테스트가 커버 못 하는 새 분기가 생겨 회귀 위험이 커진다.
  파일/함수를 분리하면 기존 코드는 전혀 안 건드리고 새 코드만 추가하면 된다.
- **조회 시점은 lazy** — 사용자가 실제로 그 언어를 선택했을 때만(00_select.sh의 메뉴
  렌더링 시점) 목록을 가져온다. 설치 시작 전에 전체 8개 언어+동반도구 목록을 미리
  다 받아오는 "prefetch/refresh 서브커맨드" 같은 건 만들지 않는다 — 이 저장소는
  "매번 설치할 때마다 한 번 쓰는" 개인 툴링이라 상시 갱신 인프라는 과설계로 판단.
- **네트워크 실패 시 폴백**: 목록 조회 자체가 실패하면 `lt_resolve_default_version()`에
  폴백 로직을 얹지 말고, 기존 `ask_version()`의 "default vs 자유입력" 흐름으로 그대로
  내려간다(TASK-129에서 UI가 이 폴백을 어떻게 사용자에게 보여줄지 다룸). 목록 캐싱
  실패가 설치 전체를 막아서는 안 된다는 원칙(TASK-119.3과 동일)을 유지.
- 실제 구현은 TASK-128.1(헬퍼)/128.3(캐싱)이 담당 — 이 결정은 설계까지만.
