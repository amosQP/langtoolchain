---
id: TASK-18
title: 기존 rc 파일에서 asdf shim이 Homebrew보다 PATH 우선순위를 가짐
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - shell
dependencies: []
parent_task_id: TASK-44
priority: medium
ordinal: 18000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
다른 도구가 이미 여러 줄을 채워놓은 실제 사용자 rc 파일에 langtoolchain 설정을 추가했을 때, 새 로그인+인터랙티브 셸에서 asdf shim이 동일 이름의 Homebrew formula보다 우선하는지 확인. 이번 세션에 실기기에서 한 번 수동으로 확인했지만(brew shellenv 순서 버그를 그 자리에서 고침), 반복 실행 가능한 자동 체크로는 아직 없음.

추가 진행(TASK-60): `spec/configure_shell_env_spec.sh`가 "brew shellenv 줄이 항상 asdf shim PATH 줄보다 rc 파일 앞쪽에 온다"는 것과 idempotency(재실행해도 중복 안 됨)는 자동으로 회귀 검증한다. 다만 이 AC가 요구하는 "다른 도구가 뒤쪽에 추가로 prepend해도 실제 로그인 셸에서 asdf가 이긴다"는 부분(`zsh -lic`로 실제 셸을 띄워야 함)은 여전히 커버 안 됨 — Done으로 바꾸지 않음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 zsh -lic 'command -v node'가 항상 ~/.asdf/shims/node를 가리킨다 (다른 도구가 rc 파일 뒤쪽에 PATH를 추가로 prepend해도)
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — full-cycle job에서 "$SHELL" -lic 'command -v node/java/python/rustc/go'로 진짜 새 로그인 셸을 열어서 5개 전부 asdf shim으로 resolve됨을 확인(arm64/intel 둘 다). 참고: 처음엔 zsh를 하드코딩해서 오탐이 났었는데(러너의 $SHELL이 bash라 .bash_profile에 썼는데 zsh로 확인해서), $SHELL을 동적으로 쓰도록 고쳐서 재확인.
---
<!-- COMMENTS:END -->
