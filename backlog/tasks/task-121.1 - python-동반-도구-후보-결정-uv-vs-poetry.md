---
id: TASK-121.1
title: python 동반 도구 후보 결정 (uv vs poetry)
status: To Do
assignee: []
created_date: '2026-08-30 12:01'
labels: []
dependencies: []
parent_task_id: TASK-121
type: task
ordinal: 158000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
python 생태계의 대표 패키지 관리자 후보인 uv와 poetry 중 이 저장소의 동반 도구로 무엇을 기본 채택할지 결정한다. 판단 기준: asdf 플러그인 존재 여부/성숙도, 설치 방식(uv는 단일 바이너리, poetry는 pip/pipx 경유가 흔함 — 이 저장소가 이미 asdf 플러그인 체계를 쓰고 있어 asdf-uv/asdf-poetry 플러그인 성숙도가 중요), 최근 생태계 채택 추세.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 uv/poetry 중 하나(또는 둘 다 지원)가 결정되고 근거가 기록됨
<!-- AC:END -->
