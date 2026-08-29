---
id: TASK-96.1
title: 잘못된 입력 에러 메시지 품질
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 13:33'
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
수정 완료: install/main.sh의 else 분기에서 무조건 출력하던 'Installation cancelled.'를 제거 — 00_select.sh가 die()나 자체 취소 메시지로 이미 이유를 설명하므로 중복/오해 소지 있던 문구였음. 라이브로 잘못된 --local 디렉토리 재현 시 'ERROR: Directory not found: ...' 한 줄만 출력됨을 확인.
<!-- SECTION:NOTES:END -->
