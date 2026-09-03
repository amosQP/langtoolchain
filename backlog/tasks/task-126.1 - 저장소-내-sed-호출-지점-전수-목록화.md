---
id: TASK-126.1
title: 저장소 내 sed 호출 지점 전수 목록화
status: In Progress
assignee: []
created_date: '2026-09-03 01:15'
updated_date: '2026-09-03 01:29'
labels: []
dependencies: []
modified_files:
  - scripts/lint/sed-portability-audit.md
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
- [x] #1 저장소 전체 sed 호출 지점이 파일:줄번호로 목록화됨
- [x] #2 각 호출에 사용된 옵션(-i, -E/-r 등)이 함께 기록됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
저장소 전체(scripts/, spec/, .github/, install.sh, uninstall.sh)를 grep -rn으로 검색해 실제 sed 호출 지점 2곳을 확인 - scripts/lib.sh:601(version_core, -n BRE 읽기전용)과 scripts/uninstall/03_clean_env_vars.sh:61(-E -i '.bak', rc 파일 in-place 편집). 그 외 매치는 전부 sed를 언급하는 주석. .github/workflows/와 spec/에는 sed 호출 없음. scripts/lint/sed-portability-audit.md에 파일:줄/옵션/컨텍스트 표로 기록.
<!-- SECTION:FINAL_SUMMARY:END -->
