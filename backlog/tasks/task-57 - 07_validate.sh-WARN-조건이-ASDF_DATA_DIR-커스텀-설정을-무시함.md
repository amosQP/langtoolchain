---
id: TASK-57
title: 07_validate.sh WARN 조건이 ASDF_DATA_DIR 커스텀 설정을 무시함
status: To Do
assignee: []
created_date: '2026-08-24 13:03'
labels:
  - code-quality
  - enhancement
milestone: m-5
dependencies: []
priority: low
type: enhancement
ordinal: 57000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
07_validate.sh가 shim 경로를 하드코딩된 문자열 '.asdf/shims/'로 매칭해서 OK/WARN을 가른다. 하지만 lib.sh의 ensure_asdf_on_path()는 사용자가 이미 ASDF_DATA_DIR을 커스텀 경로로 설정해뒀으면 그걸 존중하도록 만들어져 있다 — 즉 정상적으로 지원되는 설정인데도, 그 경로 이름이 우연히 '.asdf/shims/'라는 리터럴 문자열을 포함하지 않으면(예: 점으로 시작하지 않는 커스텀 이름) 검증 로직이 항상 WARN을 잘못 띄운다. 실기기 회귀 테스트 중 임시로 비표준 이름의 격리 디렉토리를 썼다가 우연히 발견. 낮은 우선순위 — 실사용자가 커스텀 ASDF_DATA_DIR을 쓰는 경우는 드묾.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 '.asdf/shims/' 하드코딩 대신 실제 $ASDF_DATA_DIR/shims/ 값과 비교하도록 수정
<!-- AC:END -->
