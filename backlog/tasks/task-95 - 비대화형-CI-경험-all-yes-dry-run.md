---
id: TASK-95
title: 비대화형/CI 경험 (--all/--yes/--dry-run)
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:47'
labels: []
milestone: m-6
dependencies: []
type: task
ordinal: 95000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
자동화 사용자가 프롬프트 없이 실행할 때(--all --yes) 또는 미리보기(--dry-run)만 할 때, 로그만 보고도 무슨 일이 일어나는지/일어날지 충분히 알 수 있는지 점검. tty 없는 환경 자동 폴백(TASK-26) 시 안내 문구도 포함.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
하위 3개(95.1-3) 전부 리뷰 완료. 95.1(tty 없는 환경 무안내 폴백)은 실제 갭으로 확인됐으나 미수정 상태로 남김 — 우선순위 낮음, 후속 세션에서 판단 필요.
<!-- SECTION:NOTES:END -->
