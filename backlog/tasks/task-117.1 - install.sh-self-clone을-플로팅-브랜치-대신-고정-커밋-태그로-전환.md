---
id: TASK-117.1
title: install.sh self-clone을 플로팅 브랜치 대신 고정 커밋/태그로 전환
status: Done
assignee: []
created_date: '2026-08-30 11:33'
updated_date: '2026-09-03 01:13'
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
- [x] #1 기본 실행 경로(BRANCH 미지정)에서 고정된 참조(커밋 SHA 또는 서명된 태그)로 클론됨
- [x] #2 커스텀 --branch 지정 시의 기존 동작(개발자 편의)이 깨지지 않음, 혹은 의도적으로 경고와 함께 허용됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
install.sh:70/uninstall.sh 동일 위치의 git clone --branch "$BRANCH"를 init+remote add+fetch --depth 1 <ref>+checkout FETCH_HEAD 방식(clone_pinned())으로 전환. BRANCH 기본값을 'main'에서 고정 커밋 SHA(896b4c5a7ecf82f43056d0cae7bb787f1ab3ee83, 이 작업 시작 시점의 origin/main HEAD)로 변경. fetch 기반 방식은 SHA/태그/브랜치명을 모두 동일하게 받을 수 있어(로컬 bare repo로 3가지 다 검증 완료) 향후 TASK-117.6의 환경변수 오버라이드가 어떤 종류의 참조를 넘기든 동일 코드 경로로 처리됨. shellcheck -s sh 클린, dash -n 통과, shellspec 132/132(bash+dash) 통과, --dry-run 전체 플로우 확인.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
install.sh/uninstall.sh의 self-clone을 플로팅 브랜치(main) 대신 고정 커밋 SHA로 전환. git clone --branch를 init+fetch <ref>+checkout FETCH_HEAD 패턴(clone_pinned())으로 바꿔 SHA/태그/브랜치 어느 것이든 동일 경로로 처리 가능하게 함(TASK-117.6 사전 정지작업). 이 작업 시점 origin/main HEAD(896b4c5a)로 고정. shellcheck/dash -n/shellspec(132/132, bash+dash) 전부 통과, dry-run 전체 플로우 재확인.
<!-- SECTION:FINAL_SUMMARY:END -->
