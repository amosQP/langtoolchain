---
id: TASK-85
title: CI(e2e-verify.yml)를 PR/push에도 자동 실행
status: Done
assignee: []
created_date: '2026-08-28 09:42'
updated_date: '2026-08-28 09:58'
labels:
  - ci
milestone: m-2
dependencies: []
priority: low
type: chore
ordinal: 85000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
현재 e2e-verify.yml은 workflow_dispatch(수동)만 지원. 자동 회귀 검증을 원하면 push/PR 트리거 추가 필요 — 다만 이 워크플로는 실기기에 실제로 Homebrew/asdf를 설치/제거하는 느린 잡이라(수 분~수십 분) 매 커밋마다 돌리는 게 맞는지는 별도 판단 필요.
<!-- SECTION:DESCRIPTION:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:58
---
e2e-verify.yml에 push/pull_request(main) 트리거 추가, paths 필터로 scripts/**, install.sh, uninstall.sh, .tool-versions, 워크플로 파일 자체가 바뀔 때만 자동 실행되게 제한(README/backlog만 바뀐 커밋은 안 돔 — 잡 하나가 실기기 Homebrew/asdf 설치+제거라 수 분~수십 분 걸려서). workflow_dispatch는 그대로 유지해 필요하면 언제든 수동 실행 가능. actionlint(brew install)로 워크플로 문법 검증 — 기존에 있던 무관한 info성 shellcheck 지적 1건 외 새 이슈 없음.
---
<!-- COMMENTS:END -->
