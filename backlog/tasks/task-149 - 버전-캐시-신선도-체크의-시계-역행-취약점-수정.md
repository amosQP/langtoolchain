---
id: TASK-149
title: 버전 캐시 신선도 체크의 시계 역행 취약점 수정
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 14:00'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-119.3
priority: low
type: task
ordinal: 222000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: lib.sh의 lt_cached_version_lookup()이
[ $((now - ts)) -lt "$LT_VERSION_CACHE_TTL" ]로 신선도를 판단하는데, ts가 현재 시각보다
미래인 경우(시스템 시계가 일시적으로 앞으로 갔다가 NTP로 되돌아온 경우 등) now - ts가
음수가 되고, 음수는 항상 양수인 TTL보다 작으므로 그 캐시 엔트리를 영원히 "신선함"으로
오판한다. now < ts인 경우도 별도로 감지해서 stale 취급하도록 수정.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lib.sh의 lt_cached_version_lookup()에 ts > now(시계 역행) 감지 조건을
추가: [ "$ts" -le "$now" ] || return 1 을 기존 TTL 비교 앞에 삽입. 이제 미래
타임스탬프 캐시 엔트리는 TTL 비교와 무관하게 즉시 stale 취급되어 재조회를
유발한다.

검증: spec/lib_spec.sh에 미래 타임스탬프(now+3600) 캐시 엔트리 케이스 추가.
수정 전 코드로 해당 테스트만 단독 실행 시 FAILED(기대 12.3.1, 실제 9.9.9로
영구 신선 캐시 재현) 확인 후, 수정 반영하여 재실행 시 PASS 확인. lib_spec.sh
전체 101 examples 0 failures, 전체 스위트 178 examples 0 failures.
shellcheck scripts/lib.sh 수정 라인 주변 신규 경고 없음(기존 SC2034/SC3043류
사전 존재 경고만). 실제 $HOME/네트워크 미접촉(전 테스트 mock 기반).
<!-- SECTION:FINAL_SUMMARY:END -->
