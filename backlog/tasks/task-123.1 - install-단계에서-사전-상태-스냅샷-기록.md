---
id: TASK-123.1
title: install 단계에서 사전 상태 스냅샷 기록
status: To Do
assignee: []
created_date: '2026-08-30 12:00'
labels: []
dependencies: []
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
- [ ] #1 asdf 설치 여부/데이터 디렉토리 존재 여부/기존 플러그인 목록이 01_bootstrap_asdf.sh 실행 전에 기록됨
<!-- AC:END -->
