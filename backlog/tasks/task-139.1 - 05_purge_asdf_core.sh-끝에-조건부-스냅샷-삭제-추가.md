---
id: TASK-139.1
title: 05_purge_asdf_core.sh 끝에 조건부 스냅샷 삭제 추가
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:09'
labels: []
dependencies: []
parent_task_id: TASK-139
type: task
ordinal: 202000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
decision-8이 지정한 대로: 05_purge_asdf_core.sh(phase 목록의 마지막)가 자기 자신의 실행이
끝까지 성공했을 때만 스크립트 맨 끝에서 LT_PRIOR_STATE_FILE을 rm -f 한다.
lt_snapshot_prior_asdf_state()의 DRY_RUN 가드와 동일하게 DRY_RUN=true일 땐 삭제하지
않는다. 이 phase 자체가 실패하거나(set -eu로 조기 종료) 그 이전 phase(01~04)가 실패하면
main.sh가 이후 phase를 아예 안 돌리므로 자연스럽게 삭제가 안 일어난다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
05_purge_asdf_core.sh 끝에 decision-8대로 phase 전체 성공 + DRY_RUN=false일 때만 LT_PRIOR_STATE_FILE을 rm -f 하는 조건부 삭제 추가 (lt_snapshot_prior_asdf_state()의 DRY_RUN 가드와 동일 패턴). shellcheck 통과(기존 SC1091 info만, 신규 이슈 없음).
<!-- SECTION:FINAL_SUMMARY:END -->
