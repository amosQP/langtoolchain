---
id: TASK-139
title: uninstall 전체 성공 시 prior-state 스냅샷 재수립 구현
status: In Progress
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:09'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-132
  - decision-8
priority: medium
type: task
ordinal: 201000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-132/decision-8 후속 구현. decision-8: 최초 스냅샷(LT_PRIOR_STATE_FILE)은 영구
기준선으로 유지하되, uninstall이 phase 01~05 전부 성공적으로 끝나면 그 스냅샷 파일을
지워서 다음 install이 새로 기준선을 잡게 한다. 실패한/중단된 uninstall 재시도 시에는
기존 스냅샷이 여전히 필요하므로 그 경우엔 절대 지우면 안 된다.
<!-- SECTION:DESCRIPTION:END -->
