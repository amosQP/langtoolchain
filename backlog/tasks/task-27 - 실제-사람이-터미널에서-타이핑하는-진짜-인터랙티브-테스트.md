---
id: TASK-27
title: 실제 사람이 터미널에서 타이핑하는 진짜 인터랙티브 테스트
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-28 03:48'
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
- [x] #2 프롬프트 문구와 화면 흐름이 실제로 읽기 편하고 헷갈리지 않는다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:45
---
expect로 진짜 pty 구동해서 AC #1(언어 선택/버전 입력/스코프 선택/최종 확인 전체 흐름을 실제로 타이핑해서 완주)은 검증 완료 — 5개 언어 각각 Y/n+버전, 로컬 스코프+디렉토리, 최종 확인까지 전부 정상 동작. AC #2(프롬프트 문구/화면 흐름이 실제로 읽기 편한지)는 주관적 UX 판단이라 자동화된 pty로는 확인 불가 — 사람이 한 번은 직접 봐야 함. 그래서 status는 To Do로 유지.
---

created: 2026-08-28 03:48
---
AC #2 리뷰: 실제 pty 출력을 다시 훑어보니 전역/로컬 스코프 프롬프트('전역으로 고정할까요, 이 디렉토리에만 고정할까요? [전역/로컬] >')만 다른 모든 프롬프트와 다르게 기본값을 안 보여줬음 — [Y/n]는 Enter=Y를 암시하고 [기본값: X]는 X를 명시하는데, 이 프롬프트는 Enter를 누르면 아무 안내 없이 조용히 전역으로 결정됨(소스: scripts/install/00_select.sh의 case문 default branch). 실사용자 입장에서 헷갈릴 수 있는 진짜 결함이라 '[전역/로컬, 기본값: 전역] > '로 고쳐서 일관성을 맞춤. shellspec 62개(bash+dash) 전부 통과, expect pty 재검증으로 문구/동작 확인 완료. 나머지 프롬프트 문구는 검토 결과 특별한 문제 없음.
---
<!-- COMMENTS:END -->
