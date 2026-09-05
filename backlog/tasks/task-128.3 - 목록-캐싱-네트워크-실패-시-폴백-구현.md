---
id: TASK-128.3
title: 목록 캐싱 + 네트워크 실패 시 폴백 구현
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 04:43'
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
