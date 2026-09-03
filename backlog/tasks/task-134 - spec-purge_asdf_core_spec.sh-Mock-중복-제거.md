---
id: TASK-134
title: spec/purge_asdf_core_spec.sh Mock 중복 제거
status: Done
assignee: []
created_date: '2026-09-03 11:08'
updated_date: '2026-09-03 11:27'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
spec/purge_asdf_core_spec.sh: 3개 It 예제(워크트리 기준; 원 코드리뷰는 m-13
포함 7개 기준)에 동일하게 복붙되어 있던 4줄 Mock brew 블록을 Describe
레벨(BeforeEach/AfterEach 옆)로 hoist. 검증 로직/mock 반환값은 무변경.

- Before: shellspec spec/purge_asdf_core_spec.sh -> 3 examples, 0 failures
- After:  shellspec spec/purge_asdf_core_spec.sh -> 3 examples, 0 failures
- 전체 스위트: shellspec -> 132 examples, 0 failures

주의: 이 워크트리는 TASK-124.1(4개 예제 추가)이 아직 merge 안 된 상태라
실제 파일에 3개 It만 존재 - 그 3개 기준으로 hoist를 정확히 반영함.
TASK-124.1 merge 시 신규 4개 예제도 동일 Mock을 각자 갖고 있다면 그때
다시 중복 제거가 필요할 수 있음(merge 담당자 확인 필요).
<!-- SECTION:FINAL_SUMMARY:END -->
