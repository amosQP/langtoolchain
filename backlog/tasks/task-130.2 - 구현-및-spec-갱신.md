---
id: TASK-130.2
title: 구현 및 spec 갱신
status: To Do
assignee: []
created_date: '2026-09-03 11:07'
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
