---
id: TASK-124.1
title: 05_purge_asdf_core.sh 삭제 로직을 사전 상태 기반으로 변경
status: To Do
assignee: []
created_date: '2026-08-30 12:01'
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
- [ ] #1 스냅샷상 기존 상태였던 asdf 데이터 디렉토리는 rm -rf되지 않고 스킵되거나 확인을 받음
- [ ] #2 스냅샷이 없는 경우 안전한 기본 동작(삭제 스킵 + 경고)이 적용됨
<!-- AC:END -->
