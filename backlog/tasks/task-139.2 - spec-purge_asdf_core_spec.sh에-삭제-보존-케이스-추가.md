---
id: TASK-139.2
title: spec/purge_asdf_core_spec.sh에 삭제/보존 케이스 추가
status: To Do
assignee: []
created_date: '2026-09-03 12:06'
labels: []
dependencies:
  - TASK-139.1
parent_task_id: TASK-139
type: task
ordinal: 203000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
139.1 구현에 대해 두 케이스를 mock 기반으로 추가: (1) phase 전체 성공 시 LT_PRIOR_STATE_
FILE이 실제로 삭제됨, (2) DRY_RUN=true일 땐 삭제 안 됨. "phase 실패 시 보존"은 main.sh
수준 통합이라 이 spec 파일 단위 테스트로는 05_purge_asdf_core.sh 자체가 실패하는 상황을
만들어 검증(예: brew 관련 Mock이 실패를 반환하게 해서 스크립트가 비정상 종료하는지, 그때
스냅샷 파일이 남아있는지 확인).
<!-- SECTION:DESCRIPTION:END -->
