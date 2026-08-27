---
id: TASK-6
title: curl | bash로 실제 원격 설치 전체 흐름
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - install
dependencies: []
parent_task_id: TASK-42
priority: high
ordinal: 6000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
로컬 클론이 없는 환경에서 curl -fsSL .../install.sh | bash를 실제로 실행해, git clone으로 저장소를 받아 설치까지 끝까지 성공하는지 검증. 지금까지는 로컬 클론(./install.sh) 실행만 검증했고, 진짜 curl 파이프 원격 실행 경로는 아직 한 번도 끝까지 실행해보지 않았다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 curl | bash로 시작한 설치가 임시 디렉토리에 clone → 설치 → 정리(trap으로 임시 디렉토리 삭제)까지 정상 완료된다
- [ ] #2 네트워크 문제 없이 --all --yes 조합으로 비대화형 전체 설치가 성공한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
실제 curl|sh 원격 설치 전체 흐름을 이 개발 머신에서 직접 실행해 검증(로컬 checkout이 있어도 곧장 실행하는 게 아니라, /tmp에서 curl로 받아 stdin=파이프인 상태로 진짜 git clone --depth 1 후 scripts/install/main.sh --dry-run --all --yes까지 전체 7-phase 완주). 별도로 no-git CI job에서 실패 경로(git 없을 때 우아하게 에러)도 확인.
---
<!-- COMMENTS:END -->
