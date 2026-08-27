---
id: TASK-53
title: 07_validate.sh가 설치된 버전이 요청한 버전과 일치하는지 확인 안 함
status: Done
assignee: []
created_date: '2026-08-24 12:53'
labels:
  - code-quality
  - enhancement
milestone: m-5
dependencies: []
priority: low
type: enhancement
ordinal: 53000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
07_validate.sh는 각 언어의 바이너리가 asdf shim을 통해 PATH에서 잡히고 실행되는지만 확인하고, 그 버전이 .tool-versions에 적힌 정확한 버전과 일치하는지는 검증하지 않는다. 예: 전역 기본값이 다른 버전으로 설정돼 있어도 shim 자체는 정상 resolve되므로 OK로 표시된다 (실제로 Node 22.11.0을 신규 설치하고 검증했을 때, global scope가 그대로 lts였어서 검증 로그에 22.11.0이 아니라 v24.14.0이 찍혔던 걸 그때 확인함 — 버그는 아니고 검증 로직이 그 차이를 구분 못 하는 설계상 공백). 코드 품질 이슈로, 즉시 수정하지 않고 백로그에만 기록.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 각 언어의 실제 실행 버전 문자열을 .tool-versions에 적힌 버전과 비교해서 불일치 시 명확히 WARN 하도록 개선
<!-- AC:END -->
