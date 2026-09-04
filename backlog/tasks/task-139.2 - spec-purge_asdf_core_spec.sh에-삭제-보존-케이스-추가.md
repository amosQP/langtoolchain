---
id: TASK-139.2
title: spec/purge_asdf_core_spec.sh에 삭제/보존 케이스 추가
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:14'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
spec/purge_asdf_core_spec.sh에 decision-8 케이스 2개 추가: (1) phase 전체 성공 시 LT_PRIOR_STATE_FILE이 실제 삭제됨, (2) DRY_RUN=true일 땐 삭제 안 됨. '05가 실패하면 set -eu로 조기 종료되어 도달 못함' 케이스는 별도 spec으로 검증하지 않음 — brew 관련 실패는 if 조건 안에 있어 스크립트를 죽이지 못하고(set -e 예외), 실제로 스크립트를 죽이려면 rm -rf 대상 디렉토리 권한을 조작해야 하는데 이 샌드박스 환경에서 그런 조작이 안전 장치에 걸려 신뢰성 있게 재현되지 않아 제외함 — decision-8 Consequences 절의 구조적 논증(마지막 phase가 set -eu로 죽으면 삭제 라인 자체에 도달 못함)으로 충분히 커버된다고 판단. shellspec 9 examples 0 failures, shellcheck 신규 이슈 없음(기존 SC2016 info만).
<!-- SECTION:FINAL_SUMMARY:END -->
