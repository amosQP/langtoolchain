---
id: TASK-123.2
title: 스냅샷 저장 위치/형식 정의
status: To Do
assignee: []
created_date: '2026-08-30 12:00'
labels: []
dependencies:
  - TASK-123.1
parent_task_id: TASK-123
type: task
ordinal: 155000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
123.1에서 기록한 사전 상태를 어디에/어떤 형식으로 남길지 정의한다. 기존 lt_report()(설치 리포트, TASK-107) 패턴을 참고해 $HOME 하위에 저장하되, uninstall 시점에 TASK-124가 이 파일을 읽어 삭제 범위를 결정해야 하므로 lt_report의 사람이 읽기 위한 로그 형식과는 별개로, 파싱하기 쉬운 형식(예: key=value 몇 줄)이 필요할 수 있음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 스냅샷 파일 경로와 형식이 정의되고, TASK-124(uninstall)가 이를 파싱해 읽을 수 있음이 확인됨
<!-- AC:END -->
