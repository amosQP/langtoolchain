---
id: TASK-65
title: >-
  06_validate_teardown.sh의 .asdf 하드코딩 판정을 ASDF_DATA_DIR 기준으로 수정 (TASK-57과 동일 버그,
  uninstall 쪽)
status: Done
assignee: []
created_date: '2026-08-27 09:27'
updated_date: '2026-08-27 09:40'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
priority: medium
type: bug
ordinal: 65000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
07_validate.sh는 이번 세션에 $ASDF_DATA_DIR/shims/ 기준으로 고쳤는데(TASK-57), 대칭 스크립트인 uninstall/06_validate_teardown.sh는 여전히 .asdf/shims, .asdf 리터럴 문자열로 판정한다(라인 28, 32-33). 커스텀 ASDF_DATA_DIR을 쓰는 사용자는 제거 후 검증에서 항상 오탐(FAIL)을 본다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 PATH 검증이 $ASDF_DATA_DIR/shims 기준으로 판정한다
- [x] #2 JAVA_HOME 검증이 $ASDF_DATA_DIR 기준으로 판정한다
- [x] #3 07_validate.sh와 같은 방식(리터럴 하드코딩 없음)으로 통일된다
<!-- AC:END -->
