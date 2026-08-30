---
id: TASK-112
title: 07_validate.sh 도구 검증 로직을 validate_one_tool()로 분리
status: Done
assignee: []
created_date: '2026-08-30 04:51'
updated_date: '2026-08-30 04:51'
labels: []
milestone: m-8
dependencies: []
type: task
ordinal: 127000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
PATH 체크+버전 체크를 하던 while 루프 본문(46줄)을 validate_one_tool(plugin, version)로 추출, 실패 시 반환값(1)으로 전달 - 루프는 'validate_one_tool ... || OK=false'로 요약됨.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
적용 완료. validate_one_tool(plugin, version) 추출, FAIL이면 return 1, 루프는 'validate_one_tool ... || OK=false'로 요약됨.
<!-- SECTION:NOTES:END -->
