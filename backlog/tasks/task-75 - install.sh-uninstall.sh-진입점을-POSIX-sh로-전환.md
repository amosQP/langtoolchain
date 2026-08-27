---
id: TASK-75
title: install.sh/uninstall.sh 진입점을 POSIX sh로 전환
status: To Do
assignee: []
created_date: '2026-08-27 14:41'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies:
  - TASK-73
  - TASK-74
priority: medium
type: chore
ordinal: 75000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
curl|bash 진입점 install.sh/uninstall.sh를 POSIX sh로 전환한다.
- shebang → #!/usr/bin/env sh
- ${BASH_SOURCE[0]:-} → $0 기반 자기 위치 탐지로 변경(단, curl로 스트리밍될 때 $0 값이 셸마다 다를 수 있어 로컬 클론 감지 로직을 신중히 재검토)
- exec bash "..."/bash "..." 호출을 exec sh "..."/sh "..."로 변경
- curl -fsSL .../install.sh | bash 안내 문구를 curl -fsSL .../install.sh | sh로 바꿀지 검토(README도 함께)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 install.sh/uninstall.sh가 dash로 직접 실행했을 때(로컬 클론 시나리오) 정상 동작한다
- [ ] #2 curl | sh 시나리오(스트리밍 stdin 실행)에서도 자기 위치 판별 로직이 올바르게 '로컬 클론 아님'으로 판정한다
<!-- AC:END -->
