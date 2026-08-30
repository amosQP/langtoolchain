---
id: TASK-105
title: install.sh/uninstall.sh 분리 진입점을 요구사항으로 명문화
status: Done
assignee: []
created_date: '2026-08-30 03:48'
updated_date: '2026-08-30 03:53'
labels: []
milestone: m-10
dependencies: []
type: task
ordinal: 120000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이미 현재 구조가 분리돼 있고(TASK-99~104 세션 중 README에도 '의도적으로 번들링하지 않는다'고 명시함), 이걸 회귀 방지 차원의 정식 요구사항/가드로 남겨달라는 요청. 두 스크립트가 항상 독립적으로 curl 가능한 상태를 유지하도록 확인 수단(스모크 테스트 또는 CI 체크)이 필요한지, 문서화만으로 충분한지는 착수 시 판단.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
spec/entrypoints_spec.sh 신규 추가 - install.sh/uninstall.sh가 (1) 별도 실행 가능한 파일로 둘 다 존재하고 (2) 서로를 코드 레벨(주석 제외)에서 참조/실행하지 않고 (3) 각자 독립적인 REPO_URL/BRANCH 부트스트랩을 가진다는 걸 회귀 가드로 고정. 첫 시도에서 grep이 주석 속 상호 참조(예: 'NOTE: kept in sync by hand with uninstall.sh's copy')까지 걸려서 오탐 났던 걸 주석 제외 grep으로 수정. 124/124(bash+dash) 통과.
<!-- SECTION:NOTES:END -->
