---
id: TASK-128
title: 언어/동반 도구별 설치 가능 버전 전체 목록 조회 구현
status: Done
assignee: []
created_date: '2026-09-03 01:17'
updated_date: '2026-09-05 09:05'
labels: []
milestone: m-15
dependencies:
  - TASK-127
references:
  - TASK-119
priority: medium
type: task
ordinal: 173000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-127에서 결정한 아키텍처/캐싱 전략에 따라 실제 목록 조회를 구현한다. TASK-119.1(m-12)이
만드는 헬퍼는 "기본값 1개"를 반환하는 것이고, 이 Story는 "전체 목록"을 반환하는 확장이다 --
같은 case-dispatch 스타일을 lib.sh에서 재사용하되 별도 함수로 분리한다(기존 기본값 헬퍼를
목록 헬퍼 위에 재구현해도 되고, 나란히 둬도 됨 -- 127에서 정한 방향을 따른다).
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3개 자식 태스크(128.1/128.2/128.3) 전부 Done. scripts/lib.sh에 lt_upstream_
version_list(plugin) 신규 추가 - node/pnpm/java/gradle/python/rust/golang/uv 8개
전부, decision-15대로 asdf 무관(언어 공식 소스/API만 사용). rust는 실측 후 GitHub
Releases API(rust-lang/rust)를 신규 목록 소스로 채택 - static.rust-lang.org는
디렉터리 리스팅이 없음을 확인(근거는 TASK-128.1 노트). 동반 도구(pnpm/gradle/uv)는
이미 128.1에서 커버됨을 확인, 128.2는 lt_companion_for_plugin() 연결 통합 테스트로
검증. decision-16대로 별도 캐시 계층(LT_VERSION_LIST_CACHE_FILE/TTL,
lt_cached_version_list_lookup/lt_cache_version_list)을 128.3에서 추가 - 기존
단일값 캐시/lt_upstream_latest_version()/lt_resolve_default_version()은 세
태스크 전체에서 단 한 줄도 수정하지 않음(순수 추가만).

전체 shellspec: 시작 시 102 examples -> 최종 125 examples, bash/dash 양쪽 0
failures. shellcheck 신규 경고 0건(기존 SC2034/SC3043/SC2155 베이스라인만 유지).
개발 중 java 목록 분기에서 마지막 LTS major가 skip될 때 함수 전체 exit status가
잘못 실패로 새는 버그를 실측으로 발견해 수정(if문 교체 + found 플래그).

다음 태스크(TASK-129)가 이 목록 조회+캐시 계층을 00_select.sh 선택 UI에 연결하고,
네트워크 실패 시 UI 폴백을 처리할 예정.
<!-- SECTION:FINAL_SUMMARY:END -->
