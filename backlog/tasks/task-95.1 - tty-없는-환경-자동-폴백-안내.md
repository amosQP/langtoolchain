---
id: TASK-95.1
title: tty 없는 환경 자동 폴백 안내
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 13:33'
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
수정 완료: 00_select.sh의 silent-fallback 분기(tty 없음 AND --all 아님)에서만 stderr로 'No controlling terminal detected - installing every language in ... (same as --all).' 출력. --all을 명시한 경우엔 생략. 라이브 dry-run으로 확인함.
<!-- SECTION:NOTES:END -->
