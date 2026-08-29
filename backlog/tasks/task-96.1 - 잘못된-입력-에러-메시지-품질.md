---
id: TASK-96.1
title: 잘못된 입력 에러 메시지 품질
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-96
type: task
ordinal: 104000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local 존재하지 않는 디렉토리, 잘못된 CLI 플래그(TASK-29) 등에서 에러 메시지가 원인과 해결법을 담고 있는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인됨 - 사소한 갭. 잘못된 플래그: 'Unknown option: --bogus-flag' (명확). 존재하지 않는 --local 디렉토리는 라이브 실행 결과 'ERROR: Directory not found: /nonexistent/path/xyz' 직후 'Installation cancelled.'가 이어서 출력됨 — 실제로는 하드 에러인데 마치 사용자가 스스로 취소한 것처럼 읽힐 수 있는 문구 중복. main.sh의 00_select.sh 실패 시 else 분기가 원인별 구분 없이 항상 'Installation cancelled.'를 붙임. 수정 후보로 남김.
<!-- SECTION:NOTES:END -->
