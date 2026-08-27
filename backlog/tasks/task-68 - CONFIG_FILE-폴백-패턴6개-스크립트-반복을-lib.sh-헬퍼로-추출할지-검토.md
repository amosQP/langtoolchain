---
id: TASK-68
title: CONFIG_FILE 폴백 패턴(6개 스크립트 반복)을 lib.sh 헬퍼로 추출할지 검토
status: To Do
assignee: []
created_date: '2026-08-27 09:27'
labels:
  - code-quality
  - constants-refactor
milestone: m-5
dependencies: []
priority: low
type: chore
ordinal: 68000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}" + 존재 체크가 00/02/05/06/07(install)과 01(uninstall) 총 6곳에 토씨 하나 안 틀리고 반복된다. 이건 리터럴 값 자체보다는 짧은 로직 조각이라 이번에 정한 원칙('로직은 분리 유지, 상수만 모은다')과는 결이 다르다 — lib.sh 헬퍼로 뽑을지, 지금처럼 각 스크립트가 갖고 있게 둘지부터 판단이 필요한 낮은 우선순위 항목.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 6곳의 패턴을 lib.sh 헬퍼로 추출할지 유지할지 결정하고 그 결정을 반영한다
<!-- AC:END -->
