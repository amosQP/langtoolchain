---
id: TASK-94
title: 최초 설치 경험 (대화형)
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:47'
labels: []
milestone: m-6
dependencies: []
type: task
ordinal: 94000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
curl|bash 또는 ./install.sh를 처음 접하는 사용자가 겪는 전체 흐름 — 언어/버전 선택, 전역/로컬 스코프 질문, 진행 로그, 완료 메시지 — 이 실제로 이해 가능하고 다음 행동을 명확히 안내하는지 점검. scripts/install/00_select.sh, main.sh가 대상.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
하위 4개(94.1-4) 전부 리뷰 완료. 실버그는 94.3(dry-run 완료 메시지 오표시)에서 발견되어 이미 수정됨(commit 25db8ec).
<!-- SECTION:NOTES:END -->
