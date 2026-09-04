---
id: TASK-144
title: asdf_preexisting 스냅샷이 brew uninstall asdf를 게이팅 안 함 — 실제 UAT로 확인된 버그 수정
status: To Do
assignee: []
created_date: '2026-09-04 08:56'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-130
  - decision-6
priority: high
type: bug
ordinal: 211000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high(origin/main 전체 diff 대상)가 발견하고, 이 세션의 실제 UAT로 직접
재현/확인됨: scripts/lib.sh의 lt_snapshot_prior_asdf_state()가 asdf_preexisting=true/false
를 prior-state 파일에 기록하지만, 저장소 전체에서 lt_prior_state_get asdf_preexisting을
호출하는 곳이 0곳이다. scripts/uninstall/05_purge_asdf_core.sh:23의
`brew uninstall asdf`는 `brew list asdf` 성공 여부로만 판단하고 이 스냅샷 값을 전혀
안 본다.

데이터 디렉토리(같은 파일, TASK-130 이전부터 존재하던 로직)와 개별 플러그인
(02_remove_plugins.sh, TASK-130)은 정확히 스냅샷으로 게이팅되는데 asdf 바이너리 자체만
빠져있다.

**실제 UAT로 재현됨**: 이 컴퓨터에 설치 전부터 있던 asdf(Homebrew로 설치, 여러 플러그인
보유)를 대상으로 uninstall.sh --yes를 실제 실행 → 7개 플러그인/데이터 디렉토리는 정확히
보존됐지만 `asdf` Homebrew 포뮬러 자체는 실제로 삭제됨(이 포뮬러엔 다른 의존 패키지가
없어서 Homebrew의 의존성 보호도 못 받음). README의 "설치 전부터 있던 걸 안 건드린다"는
약속과 어긋난다.
<!-- SECTION:DESCRIPTION:END -->
