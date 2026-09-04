---
id: TASK-137
title: GitHub Issues 연동(gh CLI) 도입 — backlog.md와의 역할 분담 설계
status: Done
assignee: []
created_date: '2026-09-03 11:39'
updated_date: '2026-09-03 11:43'
labels: []
milestone: m-16
dependencies: []
priority: low
type: spike
ordinal: 195000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
사용자 요청(2026-09-03): "gh cli로 이슈관리할거야... 클로드랑 같이 쓸거니까" — GitHub
Issues를 `gh` CLI로 관리하고, 그 흐름에 Claude Code(이 세션 같은)가 같이 참여하는 걸 원함.

배경: 이 저장소는 지금 태스크 관리를 전부 backlog.md CLI로 하고 있고(CLAUDE.md의 claude-rails
워크플로: task view -> In Progress -> task/<ID> 브랜치 -> 커밋 -> Done), GitHub Issues는
현재 이 저장소 워크플로에 안 쓰이고 있다(이 저장소는 public이지만 외부 이슈 트래커 연동은
없음). gh CLI 자체는 이미 이 컴퓨터에 설치돼 있다고 가정하고 시작하되, 인증 상태는 실행 시
확인한다.

이 태스크는 도입 자체를 바로 구현하지 않고, backlog.md(내부 실행 관리)와 GitHub Issues(외부
공개 채널일 수 있음)가 서로 어떤 역할을 나눠 맡을지부터 설계/결정한다 — 두 시스템이 같은
역할을 중복해서 맡으면 나중에 정합성 문제(이번 세션에서 겪은 decision ID 충돌과 비슷한
종류)가 생길 수 있으므로, 역할 경계를 먼저 명확히 하는 게 우선이다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
사용자가 직접 'gh cli 도입은 하지않는걸로' 결정(2026-09-03). backlog.md와의 역할 분담 조사를 진행하지 않고 decision-9('GitHub Issues/gh CLI 이슈 관리 도입 안 함')로 마무리 — 태스크 관리는 계속 backlog.md 단일 도구로 유지.
<!-- SECTION:FINAL_SUMMARY:END -->
