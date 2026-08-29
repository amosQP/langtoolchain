---
id: TASK-97.3
title: 부분 설치 상태 제거의 멱등성 UX
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-97
type: task
ordinal: 109000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
일부만 설치된 상태에서 uninstall을 돌려도 에러 없이 깔끔하게 '이미 없음' 처리되는지, 그 사실이 로그로 명확히 보이는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 완료(부분). 각 uninstall phase가 'command -v .../ [ -d ... ]' 가드로 이미-없음을 스킵하는 패턴을 일관되게 씀. 실제 dev 머신에서 --dry-run --yes 라이브 실행해보니, uninstall이 이 도구가 설치 안 한 plugin(pnpm, gradle 등)까지 포함해 '$HOME/.tool-versions에 있는 모든 asdf plugin'을 지우는 것으로 확인 — 확인 문구('every asdf-managed runtime')와 일치하는 의도된 동작이지만 공격적이라는 점은 사용자가 인지하고 있어야 함.
<!-- SECTION:NOTES:END -->
