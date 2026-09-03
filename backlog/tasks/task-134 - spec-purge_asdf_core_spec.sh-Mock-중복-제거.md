---
id: TASK-134
title: spec/purge_asdf_core_spec.sh Mock 중복 제거
status: To Do
assignee: []
created_date: '2026-09-03 11:08'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-124.1
priority: low
type: chore
ordinal: 190000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: 동일한 4줄 Mock brew 블록이 spec/purge_asdf_core_spec.sh의 7개
It 예제(그 중 4개는 m-13에서 신규 추가)에 복붙되어 있음 — 파일 기존 setup()/BeforeEach
훅으로 hoist 가능함을 코드리뷰가 실제로 hoist해서 검증까지 마침(7개 전부 여전히 통과).

이 태스크는 그 hoist를 실제로 반영한다. 순수 테스트 정리 — shellspec 전체 재실행으로 회귀
없음만 확인하면 됨.
<!-- SECTION:DESCRIPTION:END -->
