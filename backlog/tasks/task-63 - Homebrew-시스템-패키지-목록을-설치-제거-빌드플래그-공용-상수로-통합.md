---
id: TASK-63
title: Homebrew 시스템 패키지 목록을 설치/제거/빌드플래그 공용 상수로 통합
status: To Do
assignee: []
created_date: '2026-08-27 09:27'
labels:
  - code-quality
  - constants-refactor
milestone: m-5
dependencies: []
priority: medium
type: chore
ordinal: 63000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
openssl/readline/sqlite3/xz/zlib/tcl-tk 목록이 03_install_system_deps.sh(설치), 04_remove_system_deps.sh(제거), lib.sh의 ensure_build_flags()(빌드플래그용, xz/tcl-tk 제외 부분집합) 세 곳에 독립적으로 하드코딩되어 있다. 언어 하나가 패키지를 추가로 필요로 하게 되면 세 곳 다 손대야 하고, 하나라도 빠뜨리면 설치했는데 제거 시 안 지워지는 등의 버그로 이어진다. lib.sh에 전체 목록 상수를 두고, ensure_build_flags()가 쓰는 부분집합이 '전체 목록에서 뽑은 것'임이 코드로 드러나게 구조화한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 패키지 목록이 lib.sh 한 곳에 정의된다
- [ ] #2 03_install_system_deps.sh와 04_remove_system_deps.sh가 그 정의를 참조한다
- [ ] #3 ensure_build_flags()가 쓰는 부분집합과 전체 목록의 관계가 코드/주석으로 명확하다
<!-- AC:END -->
