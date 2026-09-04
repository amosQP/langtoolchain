---
id: TASK-147
title: 저장소 전체 local 키워드 누락 감사 및 적용
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
labels: []
milestone: m-17
dependencies: []
priority: low
type: task
ordinal: 218000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: scripts/lint/check-hardcoded-paths.sh(TASK-125.3, m-14)가 함수
지역 변수(file/line/list/old_ifs/entry 등)를 local 없이 전부 전역으로 선언한다 — 이
저장소의 확립된 관례(TASK-71: local은 POSIX 표준은 아니지만 dash 포함 사실상 모든
POSIX 호환 셸이 지원해서 계속 쓰기로 결정, lib.sh만 해도 24회 사용) 위반이다.

**사용자 확정(2026-09-04)**: local 계속 쓰는 걸로 하고, 이 스크립트뿐 아니라 저장소
전체에서 local이 필요한데 빠진 곳을 찾아 전부 적용한다 — check-hardcoded-paths.sh
하나로 스코프를 한정하지 않는다.

지금 당장 문제를 안 일으키는 이유(is_allowlisted()가 항상 caller의 현재 $file 값으로만
호출됨, POSIX for 루프가 반복 사이에 루프 변수를 다시 읽지 않음)까지 코드리뷰가 확인했지만,
향후 다른 호출 패턴이 추가되면 조용히 깨질 수 있는 잠재 위험이다.
<!-- SECTION:DESCRIPTION:END -->
