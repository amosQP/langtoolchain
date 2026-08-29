---
id: TASK-102
title: uninstall 대칭성 확인
status: Done
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:52'
labels: []
milestone: m-7
dependencies:
  - TASK-99
  - TASK-100
type: task
ordinal: 117000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_uninstall_runtimes.sh/02_remove_plugins.sh/06_set_globals.sh 등은 each_tool()로 .tool-versions를 범용적으로 순회하는 구조라 pnpm/gradle을 추가해도 코드 변경 없이 자동으로 대칭 처리될 것으로 예상 — 실제로 uninstall 시 정상적으로 같이 제거되는지 --dry-run으로 검증만.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
검증 완료, 코드 변경 없음. 01_uninstall_runtimes.sh는 TOOL_VERSIONS_FILE > $HOME/.tool-versions > repo 기본값 순으로 CONFIG_FILE을 정하고 each_tool()로 범용 순회하는 구조라 pnpm/gradle을 특별취급할 필요가 애초에 없었음. 라이브로 양방향 확인: install --dry-run --all --yes의 Phase 6(asdf set -u)에 pnpm/gradle 포함, uninstall --dry-run --yes의 Phase 1(asdf uninstall)도 $HOME/.tool-versions에서 읽어와 pnpm/gradle 포함 확인.
<!-- SECTION:NOTES:END -->
