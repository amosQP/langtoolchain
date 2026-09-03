---
id: TASK-128
title: 언어/동반 도구별 설치 가능 버전 전체 목록 조회 구현
status: To Do
assignee: []
created_date: '2026-09-03 01:17'
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
