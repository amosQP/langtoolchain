---
id: TASK-129
title: '00_select.sh 선택 UI를 실 목록 기반으로 교체, 자유 텍스트 입력 제거'
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
labels: []
milestone: m-15
dependencies:
  - TASK-128
references:
  - TASK-95
priority: medium
type: task
ordinal: 177000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/00_select.sh:282-298의 ask_version()을 TASK-128에서 만든 목록 조회 헬퍼를
써서 lt_arrow_menu 기반 "실제 조회된 버전 목록에서 선택"으로 교체하고, 현재 있는
"Enter a specific version" 자유 텍스트 입력 경로(read -r custom)를 제거한다.
<!-- SECTION:DESCRIPTION:END -->
