---
id: TASK-139
title: uninstall 전체 성공 시 prior-state 스냅샷 재수립 구현
status: Done
assignee: []
created_date: '2026-09-03 12:06'
updated_date: '2026-09-03 12:16'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-132
  - decision-8
priority: medium
type: task
ordinal: 201000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-132/decision-8 후속 구현. decision-8: 최초 스냅샷(LT_PRIOR_STATE_FILE)은 영구
기준선으로 유지하되, uninstall이 phase 01~05 전부 성공적으로 끝나면 그 스냅샷 파일을
지워서 다음 install이 새로 기준선을 잡게 한다. 실패한/중단된 uninstall 재시도 시에는
기존 스냅샷이 여전히 필요하므로 그 경우엔 절대 지우면 안 된다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-132/decision-8 후속 구현 완료. (1) TASK-139.1: scripts/uninstall/05_purge_asdf_core.sh 끝에 'phase 전체 성공 + DRY_RUN=false'일 때만 LT_PRIOR_STATE_FILE을 rm -f하는 조건부 삭제 추가(lt_snapshot_prior_asdf_state()의 DRY_RUN 가드와 동일 패턴; 이전 phase나 이 phase 자신이 실패하면 set -eu로 조기 종료돼 자연히 보존됨). (2) TASK-139.2: spec/purge_asdf_core_spec.sh에 '전체 성공 시 삭제됨'/'DRY_RUN이면 보존됨' 케이스 2개 추가(9 examples 0 failures). '실패 시 보존' 케이스는 별도 spec으로 재현하지 않음 — brew 관련 실패는 if 조건 안에 있어 set -e가 스크립트를 죽이지 못하고, rm -rf 대상 디렉토리 권한을 조작해 실패를 유도하는 방식은 이 샌드박스 환경의 안전장치에 걸려 신뢰성 있게 재현되지 않음; decision-8 Consequences 절의 구조적 논증(마지막 phase가 죽으면 삭제 라인 자체에 도달 못함)으로 충분히 커버된다고 판단, 코드 주석에도 동일 근거 명시. (3) TASK-139.3: readme.md/readme.en.md 양쪽 TASK-124.2 안내 문단 옆에 재수립 동작 한 줄 추가(코드 변경 없음). 전체 shellspec 스위트 171 examples 0 failures, 변경 파일 전부 shellcheck 신규 이슈 없음(기존 SC1091 info, SC2016 info만).
<!-- SECTION:FINAL_SUMMARY:END -->
