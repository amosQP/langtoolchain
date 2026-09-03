---
id: TASK-129.2
title: 버전 목록이 길 때(수십~수백개) UX 처리
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
labels: []
dependencies:
  - TASK-129.1
parent_task_id: TASK-129
type: task
ordinal: 179000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
node/java 등은 설치 가능 버전이 수십~수백 개에 달할 수 있다. lt_arrow_menu가 지금 지원하는
범위(고정 개수 옵션 나열)로 그대로 쓰기 어려울 수 있으므로, 스크롤/페이지네이션, 또는 "최근
N개 + LTS/안정 버전 우선 노출" 같은 필터링이 필요한지 검토하고 필요하면 lt_arrow_menu를
확장하거나 목록 표시 전 전처리 단계를 추가한다.
<!-- SECTION:DESCRIPTION:END -->
