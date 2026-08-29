---
id: TASK-94.2
title: 전역/로컬 스코프 질문 흐름
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-94
type: task
ordinal: 100000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
'전역으로 고정할까요, 이 디렉토리에만 고정할까요?' 질문과 --local 플래그 관계, 기본값이 뭔지 사용자가 프롬프트만 보고 알 수 있는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
리뷰 완료 - 기능은 명확하나 사소한 관찰. 'Pin globally, or only in this directory? [global/local, default: global] > '이 무엇을 위한 질문인지(전역 asdf 설정 vs 이 디렉토리 .tool-versions) CLI 프롬프트 자체엔 설명이 없고 README에만 보충 설명 있음. 프롬프트를 과하게 길게 만들면 스팸이 되는 트레이드오프라 버그로 보진 않음 — 참고용 관찰.
<!-- SECTION:NOTES:END -->
