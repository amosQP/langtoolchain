---
id: TASK-117.2
title: Homebrew 설치 스크립트 curl|bash에 무결성 검증 추가
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-117
type: task
ordinal: 136000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/01_bootstrap_asdf.sh:57 — retry 3 5 sh -c 'env NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"' 는 원격 스크립트를 검증 없이 즉시 bash로 실행하는 고전적 curl|bash 패턴.

Story 1(TASK-116.1) 조사에서 다룬 기법 중 실현 가능한 것을 적용: 예) Homebrew가 공식 게시하는 체크섬/서명이 있다면 대조, 없다면 최소한 스크립트를 먼저 fetch→로컬 저장→(가능한 검증)→실행의 2단계로 분리해 "받은 것 그대로 실행"의 원자성 문제라도 줄인다. 완전한 검증이 불가능하면(Homebrew가 공식 체크섬을 게시하지 않는 경우) 그 사실과 잔여 리스크를 README/코드 주석에 명시하는 것도 이 태스크의 유효한 결과물.

dry-run 게이트(01_bootstrap_asdf.sh:36-43)는 이미 있으므로 그 로직을 건드리지 않도록 주의.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Homebrew 설치 스크립트가 fetch와 실행 사이에 검증 단계(또는 명시적으로 문서화된 불가 사유)를 거침
- [ ] #2 기존 dry-run 동작(01_bootstrap_asdf.sh:36-43)이 유지됨
<!-- AC:END -->
