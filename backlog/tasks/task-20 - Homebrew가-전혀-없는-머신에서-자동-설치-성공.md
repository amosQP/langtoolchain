---
id: TASK-20
title: Homebrew가 전혀 없는 머신에서 자동 설치 성공
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - homebrew
dependencies: []
parent_task_id: TASK-45
priority: high
ordinal: 20000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
brew 명령이 전혀 없는 상태에서 01_bootstrap_asdf.sh가 NONINTERACTIVE=1로 공식 설치 스크립트를 실행해 끝까지 성공하고, 이후 phase들이 정상적으로 이어지는지 확인. 이번 세션 내내 brew가 이미 있는 머신에서만 테스트해서 이 경로는 코드 리뷰만 했고 실제 실행은 안 해봤다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 brew가 없는 상태에서 설치가 sudo 비밀번호 입력 외에는 자동으로 끝까지 진행된다
- [ ] #2 설치 직후 같은 프로세스에서 ensure_brew_on_path로 brew가 바로 인식된다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — no-homebrew-bootstrap job에서 공식 Homebrew uninstall 스크립트로 brew를 실제로 완전히 지운 뒤 설치기를 돌려서 스스로 재설치하고 이어서 전체 설치까지 성공하는 것을 확인.
---
<!-- COMMENTS:END -->
