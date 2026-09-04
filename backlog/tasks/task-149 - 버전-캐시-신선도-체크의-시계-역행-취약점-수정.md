---
id: TASK-149
title: 버전 캐시 신선도 체크의 시계 역행 취약점 수정
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
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
