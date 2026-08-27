---
id: TASK-64
title: rc 파일에 쓰는 라인과 uninstall이 지우는 sed 패턴을 lib.sh 공용 정의로 통합
status: Done
assignee: []
created_date: '2026-08-27 09:27'
updated_date: '2026-08-27 14:06'
labels:
  - code-quality
  - constants-refactor
milestone: m-5
dependencies: []
priority: high
type: chore
ordinal: 64000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install/04_configure_shell_env.sh가 append_env_var/prepend_env_var에 넘기는 검색 패턴 7개와, uninstall/03_clean_env_vars.sh의 sed -E 삭제 패턴 7개가 완전히 독립적으로 타이핑되어 있다. 정확히 이 종류의 어긋남 때문에 TASK-56(BSD sed에서 Java home 훅 못 지우던 버그)이 실제로 발생했었다. bash 3.2라 연관배열은 못 쓰므로, lib.sh에 '검색패턴 + 기록할 내용'을 한 곳에서 정의하는 구조(병렬 인덱스 배열이나 케이스문 기반 accessor 등)를 만들고 04_configure_shell_env.sh(기록)와 03_clean_env_vars.sh(삭제) 양쪽이 그 정의를 참조하도록 통합한다. 이 저장소에서 재발 가능성이 가장 높은 버그 클래스.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 rc 파일 라인의 검색패턴/내용이 lib.sh 한 곳에 정의된다
- [x] #2 04_configure_shell_env.sh와 03_clean_env_vars.sh 둘 다 그 정의를 참조한다(패턴을 각자 재입력하지 않는다)
- [x] #3 새 rc 라인을 추가할 때 한 곳만 고치면 설치/제거 양쪽에 자동 반영된다
<!-- AC:END -->
