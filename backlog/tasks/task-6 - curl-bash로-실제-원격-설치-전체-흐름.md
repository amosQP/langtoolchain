---
id: TASK-6
title: curl | bash로 실제 원격 설치 전체 흐름
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
labels:
  - test
  - install
dependencies: []
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
