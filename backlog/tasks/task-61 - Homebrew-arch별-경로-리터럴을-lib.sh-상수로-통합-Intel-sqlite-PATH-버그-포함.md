---
id: TASK-61
title: Homebrew arch별 경로 리터럴을 lib.sh 상수로 통합 (Intel sqlite PATH 버그 포함)
status: Done
assignee: []
created_date: '2026-08-27 09:27'
updated_date: '2026-08-27 09:40'
labels:
  - code-quality
  - constants-refactor
  - bug
milestone: m-5
dependencies: []
priority: high
type: bug
ordinal: 61000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lib.sh의 ensure_brew_on_path()와 install/04_configure_shell_env.sh가 각자 독립적으로 `case "$(uname -m)" in arm64) /opt/homebrew ... *) /usr/local ...` 분기를 갖고 있다(로직 중복). 게다가 lib.sh:187과 04_configure_shell_env.sh:58의 `/opt/homebrew/opt/sqlite/bin` PATH는 arch 분기 없이 무조건 Apple Silicon 경로라 Intel Mac에서는 틀린 경로가 된다(이번 리터럴 종속 감사 중 신규 발견한 실버그, TASK-34 미검증과 관련 가능). lib.sh에 Homebrew prefix를 계산하는 단일 함수/상수를 두고 ensure_brew_on_path/ensure_build_flags/04_configure_shell_env.sh 전부가 그걸 참조하도록 통합하면서, sqlite PATH도 그 prefix 기준으로 계산되게 고쳐 Intel Mac 버그를 함께 해결한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 lib.sh에 Homebrew prefix를 반환하는 단일 함수(또는 상수)가 생기고 ensure_brew_on_path/ensure_build_flags/04_configure_shell_env.sh가 전부 이걸 참조한다
- [x] #2 sqlite PATH 라인이 Intel(/usr/local)과 Apple Silicon(/opt/homebrew) 양쪽에서 올바른 경로를 가리킨다
- [x] #3 uname -m 기반 arch 분기 case문이 저장소 전체에서 정확히 1곳만 남는다
<!-- AC:END -->
