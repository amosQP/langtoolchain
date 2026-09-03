---
id: TASK-117.4
title: '신뢰 경계 문서화: 저장소가 검증할 수 없는 다운로드 지점 명시'
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-117
type: docs
ordinal: 138000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Story 1(TASK-116.2)에서 "통제 밖"으로 분류된 지점(대표적으로 scripts/install/05_install_runtimes.sh:39의 asdf install — 실제 런타임 소스/바이너리 다운로드는 각 asdf 플러그인 내부에서 일어나 이 저장소가 직접 검증 불가)을 README 또는 SECURITY 관련 섹션에 명시적으로 문서화한다.

목적: 사용자가 "이 저장소가 다운로드하는 모든 것을 검증한다"고 오해하지 않도록, 검증 가능한 경계와 위임된 신뢰(asdf 플러그인 생태계, Homebrew 신뢰 체인)를 구분해서 알린다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 README(또는 별도 SECURITY 문서)에 '이 저장소가 검증하는 지점'과 '위임/통제 밖 지점'이 표 또는 목록으로 구분되어 명시됨
<!-- AC:END -->
