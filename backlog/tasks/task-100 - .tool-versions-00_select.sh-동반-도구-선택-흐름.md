---
id: TASK-100
title: .tool-versions + 00_select.sh 동반 도구 선택 흐름
status: Done
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:49'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
구현 완료. .tool-versions에 pnpm 10.33.0(nodejs 다음 줄), gradle 9.4.1(java 다음 줄) 추가. 00_select.sh에 ALL_COMPANIONS 사전 계산(메인 루프가 동반 도구를 독립 질문으로 노출하지 않도록 스킵) + 부모 언어 수락 시에만 'Also install pnpm (companion to nodejs)? [Y/n]' 형태로 이어서 질문하는 로직 추가. --all 비대화형 경로는 코드 변경 없이 .tool-versions 전체를 그대로 써서 자동으로 포함됨 - 라이브 실행으로 확인함(nodejs/pnpm/java/gradle/python/rust/golang 전부 출력됨). 대화형 경로는 이 샌드박스의 pty 한계(TASK-27/95 리뷰에서 이미 확인된 while-read-loop 안 두 번째 /dev/tty read 행 이슈)로 expect 실입력 테스트는 첫 프롬프트까지만 가능했고, 코드 로직은 수동 트레이스로 검증함.
<!-- SECTION:NOTES:END -->
