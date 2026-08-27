---
id: TASK-68
title: CONFIG_FILE 폴백 패턴(6개 스크립트 반복)을 lib.sh 헬퍼로 추출할지 검토
status: Done
assignee: []
created_date: '2026-08-27 09:27'
updated_date: '2026-08-27 09:41'
labels:
  - code-quality
  - constants-refactor
milestone: m-5
dependencies: []
priority: low
type: chore
ordinal: 68000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}" + 존재 체크가 00/02/05/06/07(install)과 01(uninstall) 총 6곳에 토씨 하나 안 틀리고 반복된다. 이건 리터럴 값 자체보다는 짧은 로직 조각이라 이번에 정한 원칙('로직은 분리 유지, 상수만 모은다')과는 결이 다르다 — lib.sh 헬퍼로 뽑을지, 지금처럼 각 스크립트가 갖고 있게 둘지부터 판단이 필요한 낮은 우선순위 항목.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 6곳의 패턴을 lib.sh 헬퍼로 추출할지 유지할지 결정하고 그 결정을 반영한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 09:41
---
6곳 실사 결과: install 쪽 02_install_plugins.sh/05_install_runtimes.sh/06_set_globals.sh/07_validate.sh는 완전히 동일한 3줄(REPO_ROOT 기반 CONFIG_FILE 계산 + [[ -f ]] || die)이지만, uninstall/01_uninstall_runtimes.sh는 파일이 없을 때 die 대신 'No .tool-versions found — assuming runtimes are already gone'라는 메시지와 함께 exit 0으로 정상 종료해 실패 처리 방식이 반대다. install/00_select.sh는 TOOL_VERSIONS_FILE 폴백 자체가 없는 DEFAULT_CONFIG=$REPO_ROOT/.tool-versions라 애초 다른 목적의 코드라 패턴에서 제외했다. 헬퍼로 뽑으면 '파일이 없을 때 뭘 할지'라는 제어 흐름까지 헬퍼 뒤에 숨게 되어 각 스크립트를 단독으로 읽을 때 파악하기 더 어려워지고, 얻는 이득은 3줄->1줄 정도로 작다. 이번 리팩토링 원칙(상수는 모으고 로직은 분리 유지)에 따라 이 조각은 리터럴 상수가 아니라 짧은 로직으로 보고 추출하지 않기로 결정 — lib.sh 미수정, 6곳 현행 유지.
---
<!-- COMMENTS:END -->
