---
id: TASK-123.1
title: install 단계에서 사전 상태 스냅샷 기록
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:12'
labels: []
dependencies: []
references:
  - decision-1
parent_task_id: TASK-123
type: task
ordinal: 154000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/main.sh의 phase 실행(01_bootstrap_asdf.sh 등) 이전, 가장 이른 시점에 asdf 기존 설치 여부(brew list asdf 결과), $TARGET_ASDF_DATA_DIR(lib.sh lt_asdf_data_dir()) 기존 존재 여부, 기존 플러그인 목록(asdf plugin list, asdf 자체가 없으면 생략)을 확인해 기록하는 로직을 추가한다. 이 도구가 아무것도 건드리기 전 상태를 남겨야 하므로 반드시 01_bootstrap_asdf.sh보다 먼저 실행돼야 함.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 asdf 설치 여부/데이터 디렉토리 존재 여부/기존 플러그인 목록이 01_bootstrap_asdf.sh 실행 전에 기록됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
lib.sh에 LT_PRIOR_STATE_FILE 상수 + lt_snapshot_prior_asdf_state()(쓰기)/lt_prior_state_get()(읽기) 함수 추가. install/main.sh가 run_language_selection 직후, 01_bootstrap_asdf.sh를 포함한 phase 루프 시작 전에 lt_snapshot_prior_asdf_state를 호출하도록 연결. 저장 위치/형식은 decision-1을 따름($HOME/.langtoolchain-prior-asdf-state, key=value). spec/lib_spec.sh에 8개 예제 추가(brew/asdf Mock, 존재/부재/재실행 시 미덮어쓰기/DRY_RUN 스킵/reader 성공·실패 케이스). shellspec 전체(bash+dash) 139 examples 0 failures로 통과, shellcheck/dash -n 신규 경고 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
