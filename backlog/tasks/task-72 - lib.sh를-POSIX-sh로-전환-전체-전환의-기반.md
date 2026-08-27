---
id: TASK-72
title: lib.sh를 POSIX sh로 전환 (전체 전환의 기반)
status: Done
assignee: []
created_date: '2026-08-27 14:41'
updated_date: '2026-08-27 14:43'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies:
  - TASK-71
priority: high
type: chore
ordinal: 72000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-71 정책에 따라 scripts/lib.sh를 POSIX sh 호환으로 전환한다. 모든 phase 스크립트가 이 파일을 source하므로 여기서 확립하는 패턴(프로세스 치환 대체 방식, 배열 대체 방식 등)이 나머지 전환 작업의 기준이 된다.
- shebang #!/usr/bin/env bash → #!/usr/bin/env sh
- version_core()의 [[ =~ ]] + BASH_REMATCH → POSIX 호환 대체(예: expr 또는 case 기반 매칭)로 재작성
- [[ ]] 전부 [ ]로, 패턴 매칭이 필요한 곳(예: read_scope의 문자열 prefix 매칭)은 case문으로
- local은 유지(TASK-71에서 결정)
- 함수들이 ${BASH_SOURCE[0]}에 의존하지 않는지 확인(lib.sh 자체는 self-locate 안 함, 문제 없을 것으로 예상되나 확인 필요)
- /bin/dash로 직접 source해서 문법 에러 없는지 검증
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 scripts/lib.sh가 dash -n(또는 dash로 source)에서 에러 없이 통과한다
- [x] #2 [[ ]], BASH_REMATCH, =~ 가 lib.sh에서 전부 제거된다
- [x] #3 shellspec 관련 스펙이 그린을 유지한다(또는 POSIX 셸 기준으로 조정된다)
<!-- AC:END -->
