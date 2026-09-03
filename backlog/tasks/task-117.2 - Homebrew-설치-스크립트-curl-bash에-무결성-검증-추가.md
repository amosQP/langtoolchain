---
id: TASK-117.2
title: Homebrew 설치 스크립트 curl|bash에 무결성 검증 추가
status: Done
assignee: []
created_date: '2026-08-30 11:33'
updated_date: '2026-09-03 01:18'
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
- [x] #1 Homebrew 설치 스크립트가 fetch와 실행 사이에 검증 단계(또는 명시적으로 문서화된 불가 사유)를 거침
- [x] #2 기존 dry-run 동작(01_bootstrap_asdf.sh:36-43)이 유지됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
01_bootstrap_asdf.sh:57의 curl|bash 한 줄을 fetch_verified_homebrew_installer()+run_homebrew_installer() 두 함수로 분리: Homebrew/install을 floating HEAD 대신 고정 커밋(c8188c1d, 2026-09-02 확인 시점 HEAD)으로 pin하고, 그 커밋의 install.sh SHA-256(직접 계산, Homebrew가 공식 게시하지 않음 확인)을 하드코딩해 fetch 직후 대조 — 불일치 시 실행 거부. retry()가 매 attempt마다 진짜로 재-curl하도록 sh -c 문자열 트릭 대신 평범한 셸 함수로 재구성(함수 본문은 매 호출마다 재평가되므로). 실제 네트워크로 두 케이스(정상 체크섬 통과/의도적 불일치 거부) 스크래치 스크립트로 검증 완료. 01_bootstrap_asdf.sh:36-43의 dry-run 게이트는 if/else 구조 그대로 유지, DRY_RUN=true로 실행해 기존 already-found 단축 경로 재확인. shellcheck(사전 존재하던 SC1091/SC3043 외 신규 경고 없음), dash -n, shellspec 132/132 통과.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Homebrew 설치 스크립트 curl|bash에 체크섬 검증 추가: Homebrew/install을 고정 커밋으로 pin하고 그 커밋 install.sh의 SHA-256을 하드코딩해 fetch 직후 대조, 불일치 시 실행 거부(fetch_verified_homebrew_installer/run_homebrew_installer). 진짜 fetch-then-execute 2단계로 전환. Homebrew는 공식 체크섬/서명을 게시하지 않음을 확인(2026-09) — 이 SHA는 이 프로젝트가 직접 계산해 신뢰하는 값. dry-run 게이트 유지, shellcheck/dash -n/shellspec(132/132) 통과, 실제 네트워크로 정상/불일치 두 케이스 검증.
<!-- SECTION:FINAL_SUMMARY:END -->
