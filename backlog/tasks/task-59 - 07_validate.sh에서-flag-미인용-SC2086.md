---
id: TASK-59
title: 07_validate.sh에서 $flag 미인용 (SC2086)
status: Done
assignee: []
created_date: '2026-08-24 13:13'
labels:
  - code-quality
  - cleanup
milestone: m-5
dependencies: []
modified_files:
  - scripts/install/07_validate.sh
priority: low
type: chore
ordinal: 59000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
shellcheck SC2086: "$cmd" $flag 2>&1 형태에서 $flag가 인용 안 됨. flag_for_binary()가 항상 공백 없는 단일 토큰만 반환해서 실제 word-splitting/globbing 위험은 없었지만, 안전하게 "$flag"로 인용 처리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 5개 언어 실제 검증 결과가 수정 전후 동일함을 확인
<!-- AC:END -->
