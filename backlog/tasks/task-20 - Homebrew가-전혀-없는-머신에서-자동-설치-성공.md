---
id: TASK-20
title: Homebrew가 전혀 없는 머신에서 자동 설치 성공
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - homebrew
dependencies: []
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
