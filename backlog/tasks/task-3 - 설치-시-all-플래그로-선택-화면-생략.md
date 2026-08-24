---
id: TASK-3
title: 설치 시 --all 플래그로 선택 화면 생략
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - install
dependencies: []
priority: medium
ordinal: 3000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
언어 선택 화면 없이 .tool-versions에 있는 언어/버전이 전부 설치 대상이 되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 --all 사용 시 00_select.sh가 대화형 프롬프트를 띄우지 않는다
- [ ] #2 선택 파일에 .tool-versions의 모든 언어가 그대로 반영된다
<!-- AC:END -->
