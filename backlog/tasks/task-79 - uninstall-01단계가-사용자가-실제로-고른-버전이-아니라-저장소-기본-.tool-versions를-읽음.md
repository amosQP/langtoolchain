---
id: TASK-79
title: uninstall 01단계가 사용자가 실제로 고른 버전이 아니라 저장소 기본 .tool-versions를 읽음
status: Done
assignee: []
created_date: '2026-08-28 04:26'
updated_date: '2026-08-28 04:33'
labels:
  - bug
  - shell
milestone: m-2
dependencies: []
priority: medium
type: bug
ordinal: 79000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_uninstall_runtimes.sh는 CONFIG_FILE을 ${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}로 정하는데, uninstall/main.sh는 TOOL_VERSIONS_FILE을 절대 설정하지 않는다(주석에도 명시됨). 그래서 install 시 인터랙티브 버전 오버라이드(TASK-28, 이번 세션에 실제로 검증된 기능)로 예를 들어 node를 저장소 기본값(lts)이 아닌 커스텀 버전으로 깔았다면, 이 phase는 항상 저장소 기본 .tool-versions의 버전 문자열로 'asdf list $plugin $version'을 확인하고, 실제로 설치된 버전과 다르므로 'Already absent'라고 (사실과 다르게) 로그를 찍고 진짜 설치된 버전은 건드리지 않는다. 전체 uninstall/main.sh 플로우에서는 05_purge_asdf_core.sh가 $ASDF_DATA_DIR 전체를 rm -rf 하기 때문에 최종 상태에는 영향이 없지만, main.sh 자체 주석이 명시하는 '각 phase는 독립적으로 정확하고 독립 실행 가능하다'는 설계 원칙과 어긋나고, 01_uninstall_runtimes.sh를 단독 실행(선택적 제거)하는 시나리오에서는 실제로 커스텀 버전 런타임이 안 지워진 채로 남는다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 글로벌 스코프로 설치된 경우, 저장소 기본 .tool-versions가 아니라 $HOME/.tool-versions가 존재하면 그걸 우선 읽는다
- [x] #2 커스텀 버전으로 install 후 01_uninstall_runtimes.sh만 단독 실행 -> 실제 설치된 커스텀 버전이 제거됨을 확인
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 04:33
---
글로벌 스코프일 때 $HOME/.tool-versions를 우선 읽도록 수정, 로컬 스코프의 커스텀 디렉토리는 install 시점 상태가 uninstall 시점에 전혀 남아있지 않아 여전히 복구 불가(구조적 한계, AC에도 명시). 독립 셸 스니펫으로 커스텀 버전이 $HOME/.tool-versions에서 정확히 읽히는 것 확인, shellspec 65/65(bash+dash) 통과.
---
<!-- COMMENTS:END -->
