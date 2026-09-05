---
id: TASK-129.1
title: ask_version()을 목록 선택 메뉴로 교체 + 자유 입력 제거
status: In Progress
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 09:33'
labels: []
dependencies: []
references:
  - decision-17
parent_task_id: TASK-129
type: task
ordinal: 178000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
ask_version()의 "default (default)" vs "Enter a specific version" 2지선다를, TASK-128
헬퍼가 반환한 실제 버전 목록을 lt_arrow_menu(00_select.sh:130-273 근방 기존 구현 재사용)로
보여주고 그 중 하나를 고르는 방식으로 바꾼다. read -r custom 자유 입력 경로는 완전히 제거한다.
default 값은 목록에서 강조 표시하거나 최상단에 배치해 기존 "빠르게 default로 진행" UX를
유지한다.
<!-- SECTION:DESCRIPTION:END -->
