---
id: TASK-105
title: install.sh/uninstall.sh 분리 진입점을 요구사항으로 명문화
status: To Do
assignee: []
created_date: '2026-08-30 03:48'
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
