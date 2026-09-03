---
id: TASK-125.4
title: 기존 스크립트 전수 스캔 및 잔여 위반 사례 문서화
status: In Progress
assignee: []
created_date: '2026-09-03 01:14'
updated_date: '2026-09-03 01:27'
labels: []
dependencies:
  - TASK-125.3
modified_files:
  - scripts/lint/hardcoded-paths-patterns.md
parent_task_id: TASK-125
type: task
ordinal: 165000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-125.3에서 구현한 감지 장치를 scripts/ 전체(install/, uninstall/, lib.sh, main.sh 등 기존 코드)에 돌려 위반 사례를 찾는다. 발견된 위반은 이 자리에서 직접 고치지 않는다 — 각각 별도 버그 태스크로 backlog에 새로 등록만 하고(재현 근거로 이 스캔 결과를 --doc 또는 --ref로 연결), 최종 보고에 새로 만든 태스크 ID 목록을 남긴다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 scripts/ 전체에 감지 장치를 실행한 결과가 기록됨
- [x] #2 위반 사례가 있으면 각각 별도 버그 태스크로 생성되고 이 태스크에서 그 자리 수정은 하지 않음
- [x] #3 위반 사례가 없으면 그 사실이 문서화됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
check-hardcoded-paths.sh를 인자 없이 실행해 install.sh/uninstall.sh/scripts/lib.sh/scripts/install/*.sh(8개)/scripts/uninstall/*.sh(6개), 총 17개 파일 전수 스캔 - 위반 0건. 세 패턴 각각 allowlist 없는 원시 grep으로 교차검증해도 실제 코드 경로의 하드코딩은 없었고(lib.sh 정의부 또는 주석 줄만 매치) TASK-57/61/65/70 수정 이후 재발이 없음을 확인. 결과를 scripts/lint/hardcoded-paths-patterns.md에 문서화. 위반 사례가 없어 신규 버그 태스크는 생성하지 않음(AC2).
<!-- SECTION:FINAL_SUMMARY:END -->
