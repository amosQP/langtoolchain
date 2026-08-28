---
id: TASK-88
title: 네트워크 일시 장애 자동 재시도
status: Done
assignee: []
created_date: '2026-08-28 10:02'
updated_date: '2026-08-28 10:10'
labels:
  - feature
  - shell
milestone: m-2
dependencies: []
priority: high
type: feature
ordinal: 88000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
git clone/brew install/asdf install/asdf plugin add가 네트워크 문제로 한 번 실패하면 그걸로 전체 설치가 중단된다. lib.sh에 retry(max_attempts, delay, cmd...) 헬퍼(지수 백오프) 추가하고 01_bootstrap_asdf.sh, 02_install_plugins.sh, 03_install_system_deps.sh, 05_install_runtimes.sh의 네트워크 호출과 install.sh/uninstall.sh의 git clone(lib.sh 못 씀, 인라인 재시도)에 적용.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 retry()가 실패 시 지수 백오프로 최대 N번 재시도하고, 성공하면 즉시 반환한다
- [x] #2 DRY_RUN에서는 재시도 로직이 중복 출력 없이 자연히 스킵된다
- [x] #3 shellspec 회귀 테스트 추가
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 10:10
---
lib.sh에 retry(max_attempts, delay, cmd...) 추가(지수 백오프). 01_bootstrap_asdf.sh(Homebrew 설치+brew install asdf), 02_install_plugins.sh(plugin update/add), 03_install_system_deps.sh(brew install), 05_install_runtimes.sh(asdf install)에 적용. install.sh/uninstall.sh는 lib.sh를 못 써서 git clone에 인라인 재시도 루프 작성. Homebrew 설치 스크립트는 curl 치환이 sh -c 안에서 매 시도마다 새로 평가되도록 특별히 처리(안 그러면 첫 시도에서만 fetch됨). shellspec 3예제 추가(성공/재시도 후 성공/전부 소진 후 실패), 88/88(bash+dash) 통과, 실제 dry-run으로 재시도 로직이 dry-run 중 중복 출력 없이 스킵되는 것도 확인.
---
<!-- COMMENTS:END -->
