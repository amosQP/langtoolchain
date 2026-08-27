---
id: TASK-67
title: install.sh/uninstall.sh의 REPO_URL·BRANCH 중복 정리 (진입점 특수 케이스)
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
ordinal: 67000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh:15-16과 uninstall.sh:12-13이 동일한 REPO_URL/BRANCH를 각자 정의한다. 이 둘은 lib.sh를 소스하기 전에 실행되는 진입점이라(curl|bash 시점엔 아직 저장소를 clone하지도 않은 상태) lib.sh를 그대로 공유할 수 없는 특수 케이스 — 닭과 달걀 문제. 두 파일에 값이 남더라도 반드시 일치해야 한다는 사실을 주석으로 명시하거나, 최상위에 아주 작은 공용 상수 파일을 두고 두 곳이 그걸 읽게 하는 방법을 검토한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 REPO_URL/BRANCH 값이 한 곳에서 관리되거나, 두 곳에 남더라도 반드시 동기화해야 한다는 게 명확히 문서화된다
<!-- AC:END -->
