---
id: TASK-62
title: ASDF_DATA_DIR 기본값($HOME/.asdf)을 lib.sh 상수로 통합
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
ordinal: 62000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lib.sh의 ensure_asdf_on_path(), install/04_configure_shell_env.sh(rc 파일에 리터럴로 기록), uninstall/05_purge_asdf_core.sh(제거 대상 경로) 세 곳이 각자 $HOME/.asdf를 독립적으로 하드코딩하고 있다. 하나만 바뀌면 asdf의 실제 데이터 위치와 uninstall의 삭제 대상이 어긋나는 구조. lib.sh에 기본값을 상수/함수로 두고 세 스크립트 모두 그걸 참조하도록 통합한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 $HOME/.asdf 리터럴이 lib.sh 한 곳에만 정의된다
- [ ] #2 04_configure_shell_env.sh와 05_purge_asdf_core.sh가 그 정의를 참조한다(재하드코딩하지 않는다)
<!-- AC:END -->
