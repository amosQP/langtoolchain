---
id: TASK-25
title: 모든 언어를 n으로 거절 시 설치 취소
status: Done
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - interactive
dependencies: []
priority: medium
ordinal: 25000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
00_select.sh에서 모든 언어에 n으로 답하면 '선택된 언어가 없습니다' 메시지와 함께 취소되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 모든 언어 거절 시 exit 1이고 main.sh도 설치를 진행하지 않는다
<!-- AC:END -->
