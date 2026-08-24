---
id: TASK-51
title: dry-run 중 Homebrew 설치 스크립트를 실제로 curl해오던 버그
status: Done
assignee: []
created_date: '2026-08-24 12:53'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - scripts/install/01_bootstrap_asdf.sh
priority: medium
type: bug
ordinal: 51000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
01_bootstrap_asdf.sh에서 run env NONINTERACTIVE=1 bash -c "$(curl -fsSL .../install.sh)" 형태로 호출했는데, $(curl ...) 명령 치환은 run() 함수가 DRY_RUN을 확인하기도 전에 bash가 인자를 평가하는 시점에 먼저 실행된다. 즉 --dry-run에서도 Homebrew 공식 설치 스크립트를 실제로 네트워크에서 받아오고 있었고(부작용은 없지만 불필요한 요청), 만약 그 결과가 출력됐다면 수천 줄짜리 설치 스크립트 소스가 그대로 dry-run 로그에 찍힐 뻔했다. 이 경로는 이번 세션 내내 brew가 이미 있는 머신에서만 테스트해서(TASK-20 참고) 한 번도 실제로 걸린 적이 없었음 — 코드 리뷰로 발견. curl 자체를 DRY_RUN 분기 밖으로 빼서 fetch 여부까지 조건부로 만들어 수정 완료, 격리 함수 모킹으로 재현 및 수정 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 DRY_RUN=true일 때 curl이 전혀 호출되지 않는다 (모킹된 curl로 재현/검증 완료)
- [ ] #2 실제(non-dry-run) 설치 시 동작은 이전과 동일하다
<!-- AC:END -->
