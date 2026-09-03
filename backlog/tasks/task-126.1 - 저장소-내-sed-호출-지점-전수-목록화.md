---
id: TASK-126.1
title: 저장소 내 sed 호출 지점 전수 목록화
status: To Do
assignee: []
created_date: '2026-09-03 01:15'
labels: []
dependencies: []
parent_task_id: TASK-126
type: docs
ordinal: 167000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
저장소 전체(scripts/, spec/, .github/, install.sh, uninstall.sh 등)에서 'sed' 호출 지점을 grep -rn으로 전수 목록화한다. 각 호출의 파일:줄번호, 사용된 옵션(-i 포함 여부, -E/-r 사용 여부, 백레퍼런스/확장 정규식 사용 여부)을 정리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 저장소 전체 sed 호출 지점이 파일:줄번호로 목록화됨
- [ ] #2 각 호출에 사용된 옵션(-i, -E/-r 등)이 함께 기록됨
<!-- AC:END -->
