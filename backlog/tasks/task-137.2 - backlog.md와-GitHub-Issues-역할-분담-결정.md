---
id: TASK-137.2
title: backlog.md와 GitHub Issues 역할 분담 결정
status: Done
assignee: []
created_date: '2026-09-03 11:40'
updated_date: '2026-09-03 11:43'
labels: []
dependencies:
  - TASK-137.1
parent_task_id: TASK-137
type: task
ordinal: 197000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
137.1에서 정리한 시나리오를 바탕으로 역할을 결정한다: (a) GitHub Issues는 외부 사용자
버그 리포트/요청 접수용, backlog.md는 그걸 실제로 작업으로 전환한 뒤의 내부 실행 관리용
(단방향 유입) — (b) 완전 병행(양쪽 다 계속 갱신, 동기화 필요) — (c) 그 외 대안. CLAUDE.md의
기존 claude-rails 워크플로(태스크 단위 실행/브랜치/커밋 규칙)를 이 도입이 어떻게 건드리는지도
확인한다(예: gh CLI로 이슈를 다루는 것 자체는 backlog 활성 태스크 요구 훅 대상이 아님 —
Edit/Write가 아니라 Bash 호출이므로). 결론은 backlog decision으로 기록하고, 필요하면
CLAUDE.md에 새 워크플로 규칙으로 반영하는 걸 후속 태스크로 분리한다(이 태스크 자체는
결정까지만).
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
137.1과 동일 사유로 조사 없이 결정만 기록. backlog.md를 유일한 태스크 관리 도구로 유지, GitHub Issues/gh CLI 도입 안 함 (decision-9).
<!-- SECTION:FINAL_SUMMARY:END -->
