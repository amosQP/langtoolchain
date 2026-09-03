---
id: TASK-117
title: shim/설치 체인 무결성 검증 하드닝
status: Done
assignee: []
created_date: '2026-08-30 11:32'
updated_date: '2026-09-03 01:32'
labels: []
milestone: m-11
dependencies:
  - TASK-116
documentation:
  - docs/download-points-inventory.md
type: task
ordinal: 132000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Story 1(조사)의 결론을 바탕으로 이 저장소의 실제 무검증 다운로드 지점들에 검증 로직을 적용하는 구현 스토리.

대상 지점(2026-08-30 조사 확정):
- install.sh:70 — git clone --branch "$BRANCH" (플로팅 브랜치, 커밋/태그 고정·서명 검증 없음)
- scripts/install/01_bootstrap_asdf.sh:57 — Homebrew 설치 스크립트를 curl로 받아 즉시 bash로 실행 (curl|bash, 체크섬/서명 검증 없음)
- scripts/install/02_install_plugins.sh:55 — asdf plugin add (내부적으로 git clone, 커밋 SHA 미고정)
- scripts/install/07_validate.sh:46-57 — PATH 섀도잉(다른 shim이 asdf shim보다 먼저 잡히는 경우)을 WARN만 하고 FAIL하지 않음 (TASK-57 관련 기존 로직)

공용 훅 지점: scripts/lib.sh의 run()/retry() — 현재는 dry-run 게이트/재시도 래퍼일 뿐 무결성 검증 개념이 없어 여기가 자연스러운 삽입 지점.

범위 밖(명시적으로 저장소 통제 밖): scripts/install/05_install_runtimes.sh의 asdf install(런타임 소스/바이너리 다운로드)은 각 asdf 플러그인 내부에서 일어나며 이 저장소가 직접 검증할 수 없음 — 이 스토리는 대신 이 신뢰 경계를 문서화하는 것으로 커버한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-117.1~117.6 전부 완료: (1) install.sh/uninstall.sh self-clone을 고정 커밋으로 전환, (2) Homebrew 설치 스크립트에 SHA-256 체크섬 검증 추가, (3) asdf plugin add 커밋 고정은 CLI 제약으로 미채택(decision-2), (4) README에 신뢰 경계(검증 지점 vs 위임/통제 밖) 문서화, (5) PATH 섀도잉 WARN 유지 결정 및 메시지 보강(decision-3), (6) REPO_URL/BRANCH 환경변수 오버라이드 추가 + 그 덕분에 원격 clone 경로 자체를 처음 로컬 회귀 테스트화. decision-1/2/3 세 건, shellcheck/dash -n/shellspec(135/135, bash+dash) 전 구간 통과.
<!-- SECTION:FINAL_SUMMARY:END -->
