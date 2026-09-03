---
id: TASK-125.3
title: 채택한 감지 장치 구현 및 CI 연결
status: Done
assignee: []
created_date: '2026-09-03 01:14'
updated_date: '2026-09-03 01:27'
labels: []
dependencies:
  - TASK-125.2
modified_files:
  - scripts/lint/check-hardcoded-paths.sh
  - .github/workflows/e2e-verify.yml
parent_task_id: TASK-125
type: task
ordinal: 164000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-125.2에서 결정한 방식으로 감지 장치를 실제 구현하고, .github/workflows/e2e-verify.yml(또는 해당하는 CI 워크플로)에 게이트로 연결한다. 위반 시 CI가 실패해야 한다. 감지 장치 자체의 오탐 여부를 기존 통과 중인 스크립트들로 스모크 테스트.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 감지 장치가 구현되어 로컬에서 실행 가능함
- [x] #2 CI 워크플로에 연결되어 위반 시 실패함
- [x] #3 기존 통과 스크립트 대상 스모크 테스트에서 오탐 없음(또는 오탐이 있으면 원인이 문서화됨)
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lint/check-hardcoded-paths.sh(POSIX sh) 구현: TASK-125.1의 3개 자동화 가능 패턴을 grep -nE로 검사, lib.sh 정의부는 allowlist로 제외. shellcheck -s sh(SC2016은 disable 처리) 통과, dash -n 통과. 합성 위반 샘플 3건 모두 정확히 탐지. 실제 저장소 기본 스캔 대상은 0건. spec/*.sh 포함 스모크 테스트 시 14건 오탐 발견 - shellspec이 기본값 폴백 동작 자체를 검증하려고 리터럴을 의도적으로 쓴 것이었음. 그래서 기본 스캔 범위에서 spec/과 scripts/lint/ 자신을 제외하고 이유를 스크립트 헤더 주석에 문서화. e2e-verify.yml에 ubuntu-latest 기반 lint-hardcoded-paths job 신규 추가로 CI 연결. 기존 shellspec 스위트 132 examples 0 failures로 회귀 없음 확인.
<!-- SECTION:FINAL_SUMMARY:END -->
