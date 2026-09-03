---
id: TASK-137.1
title: gh CLI 사용 시나리오 정리 (Claude와 함께 쓰는 흐름 포함)
status: To Do
assignee: []
created_date: '2026-09-03 11:40'
labels: []
dependencies: []
parent_task_id: TASK-137
type: task
ordinal: 196000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
gh auth status로 인증 상태 확인. 구체적으로 어떤 시나리오에 gh CLI를 쓸지 정리한다 — 예:
사용자가 실사용 중 발견한 버그를 GitHub Issue로 등록 -> Claude Code 세션이 gh issue list/
view로 읽어와서 backlog 태스크로 전환 -> 작업 후 gh issue comment/close로 되돌려 닫기,
또는 반대로 backlog 태스크 중 외부에 공개하고 싶은 것만 gh issue create로 내보내기 등.
"클로드랑 같이 쓸거니까"라는 요청 취지에 맞게, Claude Code 세션이 실제로 관여하는 지점이
어디인지 구체적으로 나열한다.
<!-- SECTION:DESCRIPTION:END -->
