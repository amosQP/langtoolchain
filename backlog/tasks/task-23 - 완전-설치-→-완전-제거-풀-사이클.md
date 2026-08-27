---
id: TASK-23
title: 완전 설치 → 완전 제거 풀 사이클
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - uninstall
dependencies:
  - TASK-9
parent_task_id: TASK-46
priority: medium
ordinal: 23000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
처음부터 끝까지 설치를 완료해 07_validate가 전부 통과하는 상태를 만든 뒤, 곧바로 전체 제거를 실행해 06_validate_teardown도 깨끗하게 통과하는지 확인. 지금까지 설치/제거를 각각 부분적으로만 실기기에서 검증했고, 하나의 연속된 흐름으로 풀 사이클을 돌려본 적은 없다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 설치 검증(07)이 5개 언어 전부 OK로 통과한 직후, 제거를 실행하면 제거 검증(06)도 전부 OK로 통과한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — full-cycle job(arm64/intel)에서 실제 설치 -> 실제 제거까지 전체 사이클 성공, 제거 후 새 로그인 셸에서 asdf/shim이 전부 사라진 것까지 확인.
---
<!-- COMMENTS:END -->
