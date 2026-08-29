---
id: TASK-100
title: .tool-versions + 00_select.sh 동반 도구 선택 흐름
status: To Do
assignee: []
created_date: '2026-08-29 13:41'
labels: []
milestone: m-7
dependencies: []
type: task
ordinal: 115000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
.tool-versions에 pnpm/gradle 기본 버전 라인 추가(이번에 실제 맥북에서 확인한 pnpm 10.33.0, gradle 9.4.1 참고). 00_select.sh의 메인 언어 선택 루프에서 동반 도구 plugin은 독립 질문으로 노출하지 않고, 부모 언어(nodejs/java)가 Y로 수락됐을 때만 'Also install pnpm (companion to nodejs)? [Y/n]' 형태로 이어서 물어보도록 구현. --all/tty-없음 비대화형 경로는 .tool-versions 전체를 그대로 쓰는 기존 구조라 추가 코드 없이 자동으로 동반 도구까지 포함됨 — 이 부분은 확인만.
<!-- SECTION:DESCRIPTION:END -->
