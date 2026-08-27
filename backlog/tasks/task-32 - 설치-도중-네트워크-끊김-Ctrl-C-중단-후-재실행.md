---
id: TASK-32
title: 설치 도중 네트워크 끊김/Ctrl-C 중단 후 재실행
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - edge-case
dependencies: []
parent_task_id: TASK-49
priority: medium
ordinal: 32000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
런타임 다운로드/컴파일 도중 네트워크가 끊기거나 Ctrl-C로 중단된 뒤, 설치를 다시 실행했을 때 정상적으로 이어지거나 최소한 안전하게 실패하는지 확인(부분 설치 상태로 인한 이상 동작이 없는지).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 중단 후 재실행 시 이미 완료된 phase는 다시 반복하지 않거나, 반복해도 안전하다(멱등적이다)
- [ ] #2 부분적으로 설치된 언어가 있어도 다른 언어의 설치를 막지 않는다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — interrupt-and-resume job에서 설치를 백그라운드로 시작 후 90초 뒤 kill, 이어서 재실행했을 때 부분 설치 상태에서도 처음부터 끝까지 정상 완주하는 것을 확인(네트워크 끊김의 근사 시뮬레이션 — 실제 네트워크 단절 자체를 CI에서 재현하긴 어려워 프로세스 강제 종료로 대체).
---
<!-- COMMENTS:END -->
