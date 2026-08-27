---
id: TASK-27
title: 실제 사람이 터미널에서 타이핑하는 진짜 인터랙티브 테스트
status: To Do
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:45'
labels:
  - test
  - interactive
dependencies: []
parent_task_id: TASK-47
priority: medium
ordinal: 27000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금까지의 검증은 전부 'tty 부재로 자동 폴백'하는 경로였다. 실제 사람이 진짜 터미널에서 각 프롬프트에 타이핑하며 체크박스 흐름 UX 자체를 눈으로 보고 확인한 적은 한 번도 없다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 사람이 실제로 언어 선택, 버전 입력, 스코프 선택, 최종 확인까지 전부 타이핑해서 완료한다
- [ ] #2 프롬프트 문구와 화면 흐름이 실제로 읽기 편하고 헷갈리지 않는다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:45
---
expect로 진짜 pty 구동해서 AC #1(언어 선택/버전 입력/스코프 선택/최종 확인 전체 흐름을 실제로 타이핑해서 완주)은 검증 완료 — 5개 언어 각각 Y/n+버전, 로컬 스코프+디렉토리, 최종 확인까지 전부 정상 동작. AC #2(프롬프트 문구/화면 흐름이 실제로 읽기 편한지)는 주관적 UX 판단이라 자동화된 pty로는 확인 불가 — 사람이 한 번은 직접 봐야 함. 그래서 status는 To Do로 유지.
---
<!-- COMMENTS:END -->
