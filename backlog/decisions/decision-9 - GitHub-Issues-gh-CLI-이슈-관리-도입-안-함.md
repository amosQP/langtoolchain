---
id: decision-9
title: GitHub Issues/gh CLI 이슈 관리 도입 안 함
date: '2026-09-03 11:42'
status: accepted
---
## Context

TASK-137(및 자식 137.1/137.2)로 "gh CLI로 GitHub Issues를 관리하고 Claude Code 세션이
같이 관여하는 흐름"을 backlog.md 워크플로와 어떻게 병행할지 조사·설계하는 태스크를
백로깅했다. 착수(137.1 시나리오 정리) 전에 사용자가 직접 "gh cli 도입은 하지않는걸로"라고
결정해서, 조사 단계를 거치지 않고 바로 기각으로 마무리한다.

## Decision

GitHub Issues/gh CLI를 이 저장소의 태스크 관리 흐름에 도입하지 않는다. 태스크 관리는
계속 backlog.md CLI 하나로만 한다(CLAUDE.md의 claude-rails 워크플로 그대로 유지).

## Consequences

- TASK-137/137.1/137.2는 조사 없이 Done 처리하고 이 decision을 근거로 남긴다.
- 이 저장소가 public이라 향후 외부 기여자용 이슈 트래커가 필요해지면 그때 다시 논의한다 —
  지금은 그 필요가 없다고 판단된 상태이지 "영구히 안 한다"는 아니다.
- backlog.md가 유일한 태스크 소스로 남아서, m-14/m-16에서 겪은 것과 같은 "여러 시스템 간
  정합성 문제"(decision ID 충돌류)가 이슈 트래커 이원화로 인해 추가로 생기는 걸 피한다.
