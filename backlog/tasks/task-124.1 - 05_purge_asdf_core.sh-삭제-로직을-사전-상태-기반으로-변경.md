---
id: TASK-124.1
title: 05_purge_asdf_core.sh 삭제 로직을 사전 상태 기반으로 변경
status: Done
assignee: []
created_date: '2026-08-30 12:01'
updated_date: '2026-09-03 01:16'
labels: []
dependencies: []
parent_task_id: TASK-124
type: task
ordinal: 156000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/uninstall/05_purge_asdf_core.sh:29-34의 rm -rf "$TARGET_ASDF_DATA_DIR" 무조건 실행 로직을 TASK-123.2에서 정의한 스냅샷을 읽어 조건부로 바꾼다. 스냅샷이 "이 도구 설치 전 이미 존재했음"을 나타내면 전체 삭제 대신 스킵 또는 명시적 확인 프롬프트로 전환.

주의: 스냅샷 자체가 없는 경우(예: 이 기능 도입 전에 이미 설치된 사용자, 또는 --dry-run으로만 설치했던 경우)의 폴백 동작도 정의해야 함 — 안전한 기본값은 "모르면 삭제하지 않고 경고".
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 스냅샷상 기존 상태였던 asdf 데이터 디렉토리는 rm -rf되지 않고 스킵되거나 확인을 받음
- [x] #2 스냅샷이 없는 경우 안전한 기본 동작(삭제 스킵 + 경고)이 적용됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/uninstall/05_purge_asdf_core.sh의 rm -rf $TARGET_ASDF_DATA_DIR 블록만 조건부로 변경: lt_prior_state_get asdf_data_dir_preexisting 값이 명시적으로 'false'일 때만 삭제하고, 'true'거나 스냅샷/키가 아예 없으면(예: 이 기능 이전 설치, --dry-run 설치) 스킵 + 수동 삭제 안내 로그 + lt_report skipped 기록. brew uninstall asdf / $HOME/.tool-versions 삭제는 AC 범위 밖이라 그대로 둠. spec/purge_asdf_core_spec.sh를 LT_PRIOR_STATE_FILE 기반으로 재작성(기존 3개 + 신규 4개=7 예제: 미존재 삭제, 커스텀 dir 삭제, dry-run, 사전존재 스킵, 스냅샷 없음 스킵, 키 없음 스킵, brew uninstall은 스킵과 무관하게 실행됨). 전체 shellspec(bash+dash) 143 examples 0 failures, shellcheck/dash -n 신규 경고 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
