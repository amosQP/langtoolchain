---
id: TASK-66
title: rc 파일 이름 목록(zshrc/bash_profile/bashrc) 정의를 install/uninstall 공용으로 검토·통합
status: To Do
assignee: []
created_date: '2026-08-27 09:27'
labels:
  - code-quality
  - constants-refactor
milestone: m-5
dependencies: []
priority: low
type: chore
ordinal: 66000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lib.sh의 detect_rc_file()은 설치 시 .zshrc/.bash_profile 중 하나만 반환하고, uninstall/03_clean_env_vars.sh는 독립적으로 .zshrc/.bash_profile/.bashrc 세 개를 순회한다(설치가 다른 셸에서 일어났을 수 있어 의도적으로 더 넓게 잡음). 지금은 의도된 비대칭이지만 문서화 안 된 암묵적 가정이다. lib.sh에 '이 도구가 아는 rc 파일 전체 목록' 상수를 명시적으로 두고 detect_rc_file()과 clean_env_vars.sh 둘 다 그 목록에서 파생되도록 정리한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 지원하는 rc 파일 전체 목록이 lib.sh 한 곳에 명시적으로 정의된다
- [ ] #2 detect_rc_file()과 03_clean_env_vars.sh가 그 목록을 참조한다
- [ ] #3 설치 시 1개만 골라 쓰고 제거 시 전체를 훑는 비대칭이 코드/주석으로 명확히 드러난다
<!-- AC:END -->
