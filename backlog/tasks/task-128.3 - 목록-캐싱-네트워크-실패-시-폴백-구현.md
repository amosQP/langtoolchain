---
id: TASK-128.3
title: 목록 캐싱 + 네트워크 실패 시 폴백 구현
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:04'
labels: []
dependencies:
  - TASK-128.2
parent_task_id: TASK-128
type: task
ordinal: 176000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
decision-16(TASK-127.2)에서 설계한 전략을 구현한다: 기존 단일값 캐시(LT_VERSION_CACHE_
FILE, TASK-119.3)는 그대로 두고, 별도의 LT_VERSION_LIST_CACHE_FILE(기본
$HOME/.langtoolchain-version-list-cache) / LT_VERSION_LIST_CACHE_TTL(기본 86400초)
로 목록을 캐싱한다. 같은 트리플파이프 라인 포맷, 값은 콤마 조인 버전 목록. 새 함수
lt_cached_version_list_lookup()/lt_cache_version_list() 추가 — 기존 단일값 캐시
함수는 건드리지 않는다.

네트워크 실패 시: lt_resolve_default_version()에 폴백 로직을 얹지 않는다. 목록 조회
자체가 실패하면 00_select.sh의 ask_version()이 기존 "default vs 자유입력" 흐름으로
내려가도록 TASK-129에서 처리한다(이 태스크는 목록 조회 계층까지만 - UI 폴백은
TASK-129.1 범위).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
decision-16 그대로 구현: LT_VERSION_LIST_CACHE_FILE(기본
$HOME/.langtoolchain-version-list-cache)/LT_VERSION_LIST_CACHE_TTL(기본 86400) 신규
변수, lt_cached_version_list_lookup()/lt_cache_version_list() 신규 함수. 기존
LT_VERSION_CACHE_FILE/lt_cached_version_lookup()/lt_cache_version()/
lt_resolve_default_version()은 전혀 건드리지 않음(파일 맨 끝에 새 섹션으로 추가).

라인 포맷은 기존과 동일한 트리플파이프(plugin|||timestamp|||values)이되 값 필드만
콤마 조인 - lt_cached_version_list_lookup()은 콤마를 다시 줄바꿈으로 풀어서
lt_upstream_version_list()와 동일한 "한 줄에 버전 하나" 출력 형태를 유지(드롭인 교체
가능하도록). lt_cache_version_list()는 <plugin> <versions>(줄바꿈 구분 문자열) 2개
인자를 받아 내부에서 콤마로 join - lt_cache_version()의 <plugin> <version> 시그니처와
같은 수준의 단순함 유지.

캐시 콤비네이터(예: lt_resolve_version_list())는 의도적으로 안 만듦 - decision-16/
태스크 설명이 명시한 범위가 "목록 조회 계층까지"이고, 네트워크 실패 시 폴백/UI 처리는
TASK-129 몫이라고 못박혀 있어서 추가 조합 함수는 범위 밖으로 판단.

## 테스트
spec/lib_spec.sh에 lt_cached_version_list_lookup()/lt_cache_version_list() 전용
Describe 블록 추가(8개 example): 왕복(write->read) 정상 케이스, 파일 없음/플러그인
없음 miss, TTL 만료, 미래 타임스탬프(clock skew), 손상된 타임스탬프, 플러그인별
독립 갱신, 그리고 "완전히 별도 파일"(decision-16 핵심 요구사항) 검증. shellspec 개발
중 "The contents of file ... should include"를 When call보다 먼저 쓰면 "Expectation
has already been executed" 에러가 남을 발견 - 항상 When call 이후로 옮겨서 해결.

bash/dash 양쪽 125 examples 0 failures(128.2의 117 -> 125). shellcheck 신규 경고
0건. dash -n 통과.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
decision-16을 그대로 구현: LT_VERSION_LIST_CACHE_FILE/LT_VERSION_LIST_CACHE_TTL
신규 변수 + lt_cached_version_list_lookup()/lt_cache_version_list() 신규 함수를
scripts/lib.sh 맨 끝에 추가. 기존 단일값 캐시(LT_VERSION_CACHE_FILE,
lt_cached_version_lookup/lt_cache_version/lt_resolve_default_version)는 전혀
수정하지 않음 - 완전히 별도 파일/함수. 네트워크 실패 폴백/콤비네이터 함수는
의도적으로 미구현(TASK-129 범위, decision-16/태스크 설명 그대로).
spec/lib_spec.sh에 8개 example 추가, bash/dash 양쪽 125 examples 0 failures
(128.2의 117 -> 125), shellcheck 신규 경고 0건.
<!-- SECTION:FINAL_SUMMARY:END -->
