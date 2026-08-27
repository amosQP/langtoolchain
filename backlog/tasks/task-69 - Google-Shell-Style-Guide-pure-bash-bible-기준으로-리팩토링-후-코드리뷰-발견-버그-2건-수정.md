---
id: TASK-69
title: Google Shell Style Guide + pure-bash-bible 기준으로 리팩토링 후 코드리뷰 발견 버그 2건 수정
status: To Do
assignee: []
created_date: '2026-08-27 14:22'
labels:
  - code-quality
  - style-guide
milestone: m-5
dependencies: []
priority: medium
type: chore
ordinal: 69000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-61~68 리팩토링 직후 /code-review에서 실제 버그 2건을 찾았다: (1) uninstall/06_validate_teardown.sh:23이 TASK-62에서 만든 LT_ASDF_DATA_DIR_DEFAULT 상수 대신 여전히 $HOME/.asdf를 리터럴로 하드코딩(TASK-65 자신의 AC #3 위반), (2) install/04_configure_shell_env.sh:43의 prepend/append 분기가 lt_env_var_defs()의 검색패턴 문자열("brew shellenv")을 케이스문에 또 한 번 리터럴로 복제해서, lib.sh 쪽 패턴이 바뀌면 조용히 어긋날 수 있음(placement 정보가 데이터로 lib.sh에 있지 않고 소비 스크립트에 하드코딩됨).

바로 고치지 않고, 사용자가 지정한 순서대로 진행하기로 함: 먼저 Google Shell Style Guide(https://google.github.io/styleguide/shellguide.html)와 pure-bash-bible(https://github.com/dylanaraps/pure-bash-bible)을 둘 다 다운로드해서 참고 문서로 확보하고, 그 기준으로 저장소 전체 스크립트에 스타일 리팩토링을 한 번 거친 뒤, 그 다음에 위 버그 2건을 고친다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Google Shell Style Guide 문서를 다운로드해서 참고 자료로 확보한다
- [ ] #2 pure-bash-bible 문서를 다운로드해서 참고 자료로 확보한다
- [ ] #3 두 문서 기준으로 scripts/ 전체에 스타일 리팩토링을 적용한다 (bash 3.2 호환 유지, 기존 동작 변경 없음)
- [ ] #4 리팩토링 이후 uninstall/06_validate_teardown.sh가 LT_ASDF_DATA_DIR_DEFAULT를 참조하도록 수정 (코드리뷰 Finding 1)
- [ ] #5 리팩토링 이후 04_configure_shell_env.sh의 prepend/append 분기를 lt_env_var_defs()의 데이터(placement 필드)로 옮겨서 문자열 리터럴 매칭을 제거 (코드리뷰 Finding 2)
- [ ] #6 shellspec 전체 그린 확인
<!-- AC:END -->
