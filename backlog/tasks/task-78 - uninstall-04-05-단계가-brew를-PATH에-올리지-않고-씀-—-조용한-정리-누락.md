---
id: TASK-78
title: uninstall 04/05 단계가 brew를 PATH에 올리지 않고 씀 — 조용한 정리 누락
status: Done
assignee: []
created_date: '2026-08-28 04:26'
updated_date: '2026-08-28 04:32'
labels:
  - bug
  - shell
milestone: m-2
dependencies: []
priority: high
type: bug
ordinal: 78000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install 쪽 모든 phase(01_bootstrap_asdf.sh, 03_install_system_deps.sh)는 brew를 쓰기 전에 ensure_brew_on_path를 호출한다. 반면 uninstall 쪽 04_remove_system_deps.sh와 05_purge_asdf_core.sh는 lib.sh의 ensure_brew_on_path를 호출하지 않고 바로 'brew list ...'/'brew uninstall ...'을 쓴다. main.sh는 각 phase를 독립된 sh 자식 프로세스로 띄우므로(설계 원칙), 이 자식 프로세스의 PATH에 brew의 bin 디렉토리가 이미 없으면(예: 설치 직후 같은 터미널 세션에서 바로 제거를 실행하는 흔한 시나리오 — brew shellenv는 rc 파일에만 쓰여서 새 셸을 열기 전까진 현재 프로세스에 반영 안 됨) 'brew list $pkg'가 command-not-found(127)로 실패한다. 이게 if 조건 안에 있어서 set -e에 안 걸리고 그냥 조용히 skip되어, LT_BUILD_DEPS formula들과 asdf(brew formula 자체)가 실제로는 하나도 제거되지 않은 채 '완료' 메시지가 뜬다. (asdf 데이터 디렉토리 자체(rm -rf $ASDF_DATA_DIR)와 ~/.tool-versions 삭제는 이 if 블록 밖에 있어서 영향 없음.) GitHub Actions macOS 러너는 Homebrew가 이미지에 사전 설치되어 있고 bin 디렉토리가 시스템 전역 PATH에 이미 포함돼 있어서, 이번 세션의 e2e CI(TASK-6 등)가 이 gap을 못 잡았다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 04_remove_system_deps.sh와 05_purge_asdf_core.sh 둘 다 brew를 쓰기 전에 ensure_brew_on_path를 호출한다
- [x] #2 brew의 bin 디렉토리가 PATH에 없는 최소 환경을 만들어 재현 -> 수정 후 formula/asdf가 실제로 제거됨을 확인
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 04:32
---
04_remove_system_deps.sh, 05_purge_asdf_core.sh 둘 다 ensure_brew_on_path 호출 추가. shellcheck(-s sh)/dash -n/shellspec(bash+dash, 65/65) 전부 통과. 부작용으로 실제 brew를 건드릴 뻔한 근접사고는 TASK-81로 별도 기록 후 즉시 수정.
---
<!-- COMMENTS:END -->
