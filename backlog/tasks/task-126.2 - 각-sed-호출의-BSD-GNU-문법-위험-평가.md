---
id: TASK-126.2
title: 각 sed 호출의 BSD/GNU 문법 위험 평가
status: To Do
assignee: []
created_date: '2026-09-03 01:15'
labels: []
dependencies:
  - TASK-126.1
parent_task_id: TASK-126
type: task
ordinal: 168000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-126.1에서 목록화한 각 sed 호출 지점을 BSD/GNU 문법 차이 관점에서 평가한다. 특히 -i(in-place) 사용 시 BSD sed(빈 문자열 인자 필수)와 GNU sed(인자 없이 동작, 또는 다른 방식) 차이, 확장 정규식(-E vs -r) 차이, \1 백레퍼런스 차이 등을 확인.

중요: 반드시 이 macOS 개발 머신의 실제 /bin/sed로 각 호출을 검증한다 — Linux GNU sed 결과나 문헌 지식만으로 판단하지 않는다. 저장소가 macOS 전용이므로 실질 위험은 '이 저장소가 GNU sed 환경(예: Homebrew gsed, Linux CI)에서 실행될 가능성이 있는가'와 '현재 macOS 기본 BSD sed에서 실제로 깨지는가' 둘 다 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 각 sed 호출 지점의 BSD/GNU 위험 여부가 실제 /bin/sed 실행 결과로 검증됨
- [ ] #2 위험 지점과 안전한 지점이 구분되어 목록에 표시됨
<!-- AC:END -->
