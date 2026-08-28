---
id: TASK-92
title: 테스트 커버리지 없던 4개 파일에 shellspec 추가
status: Done
assignee: []
created_date: '2026-08-28 14:10'
updated_date: '2026-08-28 14:10'
labels:
  - test
milestone: m-2
dependencies: []
priority: medium
type: chore
ordinal: 92000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_bootstrap_asdf.sh, 03_install_system_deps.sh(install), 02_remove_plugins.sh, 04_remove_system_deps.sh(uninstall) 4개 파일에 전용 spec가 전혀 없었다. TASK-78 근접사고가 정확히 이런 미검증 파일(04_remove_system_deps.sh)에서 나온 걸 감안해 추가. brew/asdf는 항상 Mock으로 완전히 가로채고(TASK-81 교훈 — PATH 제한만으로는 부족, ensure_brew_on_path가 고정 경로로 우회함), 매 실행 전후 실제 asdf 영수증 시각/build-dep formula 설치 상태를 대조해서 실기기 오염이 없는지 확인. 01_bootstrap_asdf.sh의 'Homebrew/asdf가 실제로 없어서 설치' 분기는 로컬에서 안전하게 흉내낼 방법이 없어서(PATH 제한이 Mock의 PATH 조작을 무력화하는 걸 실측으로 확인) 커버 안 함 — e2e-verify.yml의 no-homebrew-bootstrap 잡과 full-cycle의 최초 실행에서 실기기로 이미 커버됨.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 4개 파일 각각 최소 2개 이상 시나리오 커버
- [x] #2 brew/asdf를 실제로 건드리지 않는다 (실행 전후 시스템 상태 대조로 확인)
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 14:10
---
bootstrap_asdf_spec.sh(2예제), install_system_deps_spec.sh(2예제), remove_plugins_spec.sh(4예제), remove_system_deps_spec.sh(3예제) 신규 작성, 전체 스위트 99/99(bash+dash) 통과. 작성 전/후 실제 asdf INSTALL_RECEIPT.json time 필드와 6개 build-dep formula(openssl/readline/sqlite3/xz/zlib/tcl-tk) 설치 버전을 대조해서 완전히 동일함을 확인 — 실기기 오염 없음.
---
<!-- COMMENTS:END -->
