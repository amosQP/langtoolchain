---
id: TASK-117.3
title: asdf 플러그인 소스 커밋 고정 여부 검토
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-117
type: task
ordinal: 137000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/02_install_plugins.sh:55 — asdf plugin add "$plugin" 는 내부적으로 플러그인 저장소(예: asdf-nodejs, asdf-python)를 git clone하며, 커밋 SHA나 버전 고정 없이 항상 최신 HEAD를 받는다.

asdf 자체가 plugin add에 커밋 고정 옵션(예: asdf plugin add <name> [git-url] [ref])을 제공하는지 확인하고, 제공한다면 이 저장소가 알려진-안전 버전의 플러그인 저장소 참조를 고정할지 결정. 플러그인 업데이트 빈도/이 저장소의 유지보수 부담과 트레이드오프가 있으므로 "지금 당장 고정" 대신 "검토 후 결정 기록"이 결과물일 수 있음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 asdf plugin add의 ref 고정 가능 여부가 확인되고 문서화됨
- [ ] #2 고정하기로 결정하면 실제 적용, 하지 않기로 결정하면 근거가 backlog decision 또는 README에 기록됨
<!-- AC:END -->
