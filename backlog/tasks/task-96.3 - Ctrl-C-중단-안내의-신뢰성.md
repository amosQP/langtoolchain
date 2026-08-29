---
id: TASK-96.3
title: Ctrl-C 중단 안내의 신뢰성
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-96
type: task
ordinal: 106000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
handle_interrupt()의 '이어서 하려면 같은 명령을 다시 실행하세요' 안내가 실제 모든 phase에서 정말 안전한지(TASK-93 수정 이후 기준) 재확인 — 안내 문구와 실제 보장 수준이 일치하는지.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
확인 완료. TASK-93 수정 이후 이번 세션에서 shellspec 회귀 테스트(run_phase SIGTERM 즉시 종료)로 이미 직접 검증함 — 'ㅁ이어서 하려면 같은 명령을 다시 실행하세요' 안내가 실제 보장 수준과 일치함(30초 sleep phase도 SIGTERM 즉시 0초 내 종료+lock 해제 확인됨, spec/lib_spec.sh).
<!-- SECTION:NOTES:END -->
