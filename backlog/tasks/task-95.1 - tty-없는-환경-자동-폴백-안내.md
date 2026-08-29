---
id: TASK-95.1
title: tty 없는 환경 자동 폴백 안내
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-95
type: task
ordinal: 103000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
00_select.sh가 tty 없을 때 --all처럼 동작(TASK-26)하는데, 그 사실 자체를 사용자/로그에서 알아챌 수 있는지 점검 — 조용히 폴백하면 CI 사용자가 의도치 않은 전체 설치를 눈치 못 챌 위험.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인됨 - 실제 갭. 00_select.sh의 'if ! $INTERACTIVE || $SELECT_ALL' 분기(tty 없거나 --all)는 write_with_scope 후 바로 종료 — 이 경로엔 tty_out 안내가 전혀 없어서, tty 없는 CI 환경에서 사용자가 옵션 없이 실행하면 조용히 --all처럼 전체 설치로 전환된 사실을 로그에서 알 방법이 없음. README엔 안내가 있지만(109행) 실제 실행 로그엔 없음. 의도치 않은 전체 설치를 눈치 못 챌 위험 — 수정 후보로 남김(3건 우선순위와 별개).
<!-- SECTION:NOTES:END -->
