---
id: TASK-97.1
title: uninstall 사전 안내(무엇이 지워지는지)
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:36'
labels: []
dependencies: []
parent_task_id: TASK-97
type: task
ordinal: 107000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
uninstall.sh 실행 전/중 사용자가 asdf 전체 삭제, rc 파일 변경 등 무엇이 지워질지 미리 알 수 있는 확인 프롬프트나 로그가 있는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
수정 완료: uninstall/main.sh 확인 프롬프트 앞에 00_select.sh와 동일한 INTERACTIVE probe(`{ true < /dev/tty; } 2>/dev/null`) 추가. tty 없으면 --yes 준 것처럼 조용히 진행 — raw '/dev/tty: Device not configured' stderr 노출 제거, 실행/검증 확인함(stderr 0바이트).
<!-- SECTION:NOTES:END -->
