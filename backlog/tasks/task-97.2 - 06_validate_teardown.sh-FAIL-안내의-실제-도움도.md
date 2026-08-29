---
id: TASK-97.2
title: 06_validate_teardown.sh FAIL 안내의 실제 도움도
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-97
type: task
ordinal: 108000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
'exec $SHELL 후 다시 확인하세요' 안내가 실제 캐시 문제와 진짜 잔존 문제를 사용자가 구별하는 데 도움이 되는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 완료. 'exec $SHELL' (또는 새 터미널) 후 다시 확인하세요' 안내는 실제로 유효한 해결책 — PATH/JAVA_HOME은 이미 연 셸 세션에 캐시되므로 exec $SHELL이 정확히 그 캐시를 새로고침함. 코드 주석(06_validate_teardown.sh)도 이 근거를 명시함.
<!-- SECTION:NOTES:END -->
