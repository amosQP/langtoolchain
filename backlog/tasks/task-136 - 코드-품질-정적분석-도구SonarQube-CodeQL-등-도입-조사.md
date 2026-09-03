---
id: TASK-136
title: 코드 품질 정적분석 도구(SonarQube/CodeQL 등) 도입 조사
status: To Do
assignee: []
created_date: '2026-09-03 11:31'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-125
  - TASK-125.2
priority: low
type: spike
ordinal: 192000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
사용자 요청(2026-09-03): m-16 진행 중 SonarQube, CodeQL 같은 코드 품질/정적분석 도구를
이 저장소에 도입할 만한지 조사해달라는 요청.

배경: 지금 이 저장소는 shellcheck(-s sh)와 자체 grep 기반 lint(scripts/lint/
check-hardcoded-paths.sh, m-14/TASK-125)만 쓰고 있다. SonarQube/CodeQL 같은 범용 정적분석
도구는 대부분 컴파일 언어(Java/C/C++/C#/Go/JS/Python 등) 위주로 만들어져 있어서, 이
저장소처럼 POSIX sh 전용 프로젝트에 실제로 유의미한 커버리지를 주는지부터 확인이 필요하다
(예: CodeQL은 셸 스크립트를 공식 지원 언어 목록에 넣지 않는 것으로 알려져 있고, SonarQube는
에디션에 따라 shell/bash 분석 플러그인이 있을 수 있음 — 정확한 지원 범위는 이 태스크에서
직접 확인).

이 마일스톤(m-16)이 "코드 리뷰 후속 조치"라는 성격에 맞게, 도구 도입 자체를 이 태스크에서
바로 실행하지 않고 조사·비교·채택 여부 결정까지만 다룬다.
<!-- SECTION:DESCRIPTION:END -->
