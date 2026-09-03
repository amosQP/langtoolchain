---
id: TASK-116.2
title: 저장소 내 다운로드 지점 전수 매핑 및 현재 검증 상태 문서화
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-116
type: spike
ordinal: 134000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
2026-08-30 Explore agent 조사로 이미 1차 목록이 나왔으나, 정식 산출물(문서 또는 backlog task notes)로 정리되지 않았다. 이 태스크는 그 조사를 검증·보강하여 확정 문서로 남긴다.

이미 확인된 지점 (재검증 후 문서화):
- install.sh:70 — self-clone, git clone --depth 1 --branch "$BRANCH", 브랜치 플로팅
- scripts/install/01_bootstrap_asdf.sh:57 — Homebrew 설치 스크립트 curl|bash, 무검증
- scripts/install/01_bootstrap_asdf.sh:82 — brew install asdf, Homebrew bottle 서명에 위임
- scripts/install/02_install_plugins.sh:55 — asdf plugin add (내부 git clone, 커밋 미고정)
- scripts/install/03_install_system_deps.sh:18 — brew install $LT_BUILD_DEPS, Homebrew 위임
- scripts/install/05_install_runtimes.sh:39 — asdf install (런타임 다운로드, 저장소 통제 밖)
- scripts/install/06_set_globals.sh:70-73 — asdf reshim (shim 재생성, asdf 내부 로직)
- scripts/install/07_validate.sh:46-57 — PATH 섀도잉 WARN 체크 (shim 생성물 자체 검증 아님)

각 지점에 대해: 다운로드되는 것, 현재 검증 수준(없음/위임/부분), Story 2(TASK-117)에서 하드닝 대상인지 아니면 "통제 밖"으로 문서화만 할 대상인지 분류.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 저장소 내 모든 다운로드/설치 지점(파일:라인)이 표로 정리됨
- [ ] #2 각 지점이 '하드닝 대상' 또는 '통제 밖(문서화만)'으로 분류됨
<!-- AC:END -->
