---
id: TASK-39
title: 대화형 프롬프트에서 로컬 선택 → 디렉토리 입력 반영
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:45'
labels:
  - test
  - version-scope
dependencies: []
parent_task_id: TASK-48
priority: medium
ordinal: 39000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
대화형 흐름에서 전역/로컬 질문에 '로컬'로 답하고 디렉토리를 직접 입력했을 때, 그 값이 정확히 반영되는지 확인. 주의: 이번 세션에는 진짜 tty가 없어서 이 인터랙티브 분기(00_select.sh의 SCOPE 프롬프트, --local 플래그도 --all도 안 줬을 때만 실행됨) 자체는 한 번도 실제로 실행되지 않았다 — --all --local 조합으로 플래그 우회 경로만 테스트했었는데 Done으로 잘못 기록되어 있었다. 실제 사람이 터미널에서 답해야 검증 가능.

추가 진행(TASK-60): `spec/select_spec.sh`가 `--local=DIR` 플래그 경로(비대화형 우회 경로)는 자동 회귀 테스트로 커버한다. 위 노트가 경고하는 바로 그 함정(대화형 SCOPE 프롬프트 자체는 tty 없이 재현 불가)은 여전히 그대로 남아있고, 이 테스트로도 우회되지 않는다 — Done으로 바꾸지 않음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 입력한 디렉토리 경로가 선택 파일의 scope 줄에 정확히 기록된다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:45
---
expect로 진짜 pty 구동 검증: 전역/로컬 프롬프트에 '로컬' 입력 후 디렉토리 프롬프트에 임의 경로 입력 -> 선택 파일의 '# scope: local <경로>' 줄에 입력한 경로가 정확히 기록됨을 확인.
---
<!-- COMMENTS:END -->
