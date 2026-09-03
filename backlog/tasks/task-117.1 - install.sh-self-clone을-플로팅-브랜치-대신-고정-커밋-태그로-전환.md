---
id: TASK-117.1
title: install.sh self-clone을 플로팅 브랜치 대신 고정 커밋/태그로 전환
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-117
type: task
ordinal: 135000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh:70의 git clone --depth 1 --branch "$BRANCH" "$REPO_URL"는 브랜치 HEAD를 그대로 신뢰한다. 브랜치가 강제 push되거나 손상되면 curl|sh로 실행되는 코드가 통째로 바뀔 수 있다.

Story 1(TASK-116) 조사 결론에서 채택된 기법(예: git commit SHA 고정, 또는 signed tag + git tag -v 검증)을 실제로 적용한다. --branch 옵션이 사용자에게 열려 있는 경우(개발/테스트 브랜치 지정) 이 유연성을 깨지 않으면서 기본값(release/main) 경로에서만 고정하는 방식을 검토.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 기본 실행 경로(BRANCH 미지정)에서 고정된 참조(커밋 SHA 또는 서명된 태그)로 클론됨
- [ ] #2 커스텀 --branch 지정 시의 기존 동작(개발자 편의)이 깨지지 않음, 혹은 의도적으로 경고와 함께 허용됨
<!-- AC:END -->
