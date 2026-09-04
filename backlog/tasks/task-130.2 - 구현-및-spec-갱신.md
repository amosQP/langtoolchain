---
id: TASK-130.2
title: 구현 및 spec 갱신
status: Done
assignee: []
created_date: '2026-09-03 11:07'
updated_date: '2026-09-03 11:19'
labels: []
dependencies:
  - TASK-130.1
parent_task_id: TASK-130
type: task
ordinal: 183000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
130.1의 설계대로 scripts/uninstall/02_remove_plugins.sh를 수정 — 사전 존재 플러그인은
건너뛰고 lt_report skipped로 기록, 나머지만 asdf plugin remove. spec/remove_plugins_spec.sh
(현재 이 phase의 기존 spec 파일)에 LT_PRIOR_STATE_FILE 시나리오(사전 존재 O/X 플러그인
혼재, 스냅샷 파일 없음 폴백)를 05_purge_asdf_core.sh 갱신 때와 동일한 패턴으로 추가한다.
brew/asdf는 항상 Mock — 실제 명령 실행 금지.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
scripts/uninstall/02_remove_plugins.sh 수정: asdf_plugins_preexisting 스냅샷을 스크립트 시작 시 한 번 읽어, 플러그인별로 case 패턴(단어 경계 패딩)으로 사전존재 여부 판정. 사전존재 플러그인은 asdf plugin remove를 호출하지 않고 lt_report skipped로 기록 + 'Skipping plugin (existed before langtoolchain): <name>' 로그. 스냅샷 파일 자체가 없거나 키가 없으면(구버전 설치/‑‑dry-run 등) 05와 동일하게 안전 기본값 — 전부 사전존재로 간주해 skip.

spec/remove_plugins_spec.sh: setup()에서 LT_PRIOR_STATE_FILE을 실제 $HOME 파일과 격리된 임시 파일로 고정하고 기본값 'asdf_plugins_preexisting=' (전부 신규)을 써서 기존 4개 예제의 '전부 remove' 기대값을 그대로 유지. 신규 예제 3개 추가: (1) 사전존재/신규 혼재 - 사전존재만 skip, 나머지 remove, (2) 스냅샷 파일 자체가 없음 - 전부 skip, (3) 스냅샷은 있으나 asdf_plugins_preexisting 키가 없음 - 전부 skip. brew/asdf는 항상 Mock, 실제 명령 실행 없음.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
shellcheck 통과, scripts/lint/check-hardcoded-paths.sh 통과. spec/remove_plugins_spec.sh 7개 예제(기존4+신규3) 통과, 전체 shellspec 168 examples, 0 failures.
<!-- SECTION:FINAL_SUMMARY:END -->
