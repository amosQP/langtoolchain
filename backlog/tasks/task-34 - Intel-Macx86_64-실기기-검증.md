---
id: TASK-34
title: Intel Mac(x86_64) 실기기 검증
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - platform
dependencies:
  - TASK-20
parent_task_id: TASK-50
priority: high
ordinal: 34000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금까지 uname 모킹으로 아키텍처 분기 로직(ensure_brew_on_path, BREW_BIN case문 등)만 리뷰했고, 실제 Intel 하드웨어에서 끝까지 실행해본 적은 없다. /usr/local 접두사 경로가 실제로 맞는지 확인 필요.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 실제 Intel Mac에서 curl 한 줄 설치가 /usr/local 기준으로 끝까지 성공한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — macos-15-intel(x64) 러너에서 full-cycle 전체 성공. 참고: 이 라벨이 무료 개인 계정 public repo에서 실제로 되는지는 문서가 서로 모순됐는데, 직접 돌려봐서 된다는 것 경험적으로 확인.
---
<!-- COMMENTS:END -->
