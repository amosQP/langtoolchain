---
id: TASK-12
title: Go 신규 버전 실제 설치
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - runtime
dependencies: []
parent_task_id: TASK-43
priority: medium
ordinal: 12000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
asdf install golang으로 신규 버전을 설치하고 go/gofmt shim이 새 버전으로 정확히 갱신되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 go version이 새로 설치한 버전과 일치한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — asdf install golang 1.26.1 실제 설치 성공, go version으로 검증됨.
---
<!-- COMMENTS:END -->
