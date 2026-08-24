---
id: TASK-58
title: ensure_build_flags에서 brew --prefix 실패가 set -e에 안 걸리던 문제
status: Done
assignee: []
created_date: '2026-08-24 13:13'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - scripts/lib.sh
priority: low
type: bug
ordinal: 58000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
shellcheck SC2155로 발견: export LDFLAGS="...$(brew --prefix openssl)..." 형태는 export 자체가 항상 성공해서, 내부 명령 치환(brew --prefix)이 실패해도 set -e가 못 잡고 조용히 잘못된 값으로 넘어간다. brew --prefix 4개 호출 결과를 지역 변수에 먼저 담고 나서 export하도록 분리. 부수적으로 각 formula당 brew --prefix를 한 번씩만 호출하도록 중복 호출도 줄임.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 brew --prefix 실패 시 set -e로 즉시 중단되도록 재현/확인
- [ ] #2 실제 brew --prefix 호출로 LDFLAGS/CPPFLAGS/PKG_CONFIG_PATH 값이 기존과 동일함을 확인
<!-- AC:END -->
