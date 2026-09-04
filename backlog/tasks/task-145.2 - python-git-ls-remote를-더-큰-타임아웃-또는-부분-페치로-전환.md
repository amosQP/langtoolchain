---
id: TASK-145.2
title: python git ls-remote를 더 큰 타임아웃 또는 부분 페치로 전환
status: Done
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 14:01'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 214000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/lib.sh의 lt_upstream_latest_version() python 브랜치가 cpython 전체 태그(1000개+)
를 git ls-remote --tags --refs로 나열하는데 같은 5초 예산을 씀 — 정상 상황에서도 자주
초과해서 lt_run_with_timeout()이 죽이고 조용히 정적 기본값으로 폴백한다(기능이 사실상
안 켜짐). 더 큰 타임아웃을 주거나, git ls-remote에 refs 필터(예: v3.14.*)를 걸어 응답
크기를 줄이는 방법을 검토한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
lt_upstream_latest_version()의 python 브랜치(git ls-remote --tags --refs, cpython 태그 1000개+)가 LT_VERSION_FETCH_TIMEOUT(5s, JSON API 공유값)을 재사용하던 것을 이 호출 전용 LT_PYTHON_TAGS_TIMEOUT(기본 20s, 오버라이드 가능)으로 분리. refs 필터안은 '필터링에 필요한 최신 major.minor를 알기 위해 이 호출이 필요하다'는 순환 의존 문제로 기각하고 큰 타임아웃 예산 쪽을 채택. spec/lib_spec.sh의 블랙홀 타임아웃 테스트(TASK-138.2) 변수명 갱신. shellcheck 신규 경고 0건(기존 6건 SC2034/SC2155 그대로), shellspec(bash+dash) 177/177 통과.
<!-- SECTION:FINAL_SUMMARY:END -->
