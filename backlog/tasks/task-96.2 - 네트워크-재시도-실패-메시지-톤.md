---
id: TASK-96.2
title: 네트워크 재시도/실패 메시지 톤
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:37'
labels: []
dependencies: []
parent_task_id: TASK-96
type: task
ordinal: 105000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
retry()(TASK-88)가 찍는 'attempt N/M failed' 로그가 사용자에게 불안을 주지 않고 상황(재시도 중임)을 명확히 설명하는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
수정 완료: 사용자 결정 — 전부 영어로 통일. scripts/ 전체(lib.sh, install/*.sh, uninstall/*.sh)의 사용자 대상 문자열 21곳을 영어로 번역, spec/lib_spec.sh의 한국어 assertion 1곳과 README의 실제 출력 인용 transcript 2곳도 함께 갱신. 코드 주석/backlog/커밋 메시지는 한국어 유지(범위 밖).
<!-- SECTION:NOTES:END -->
