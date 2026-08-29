---
id: TASK-96
title: 에러/예외 메시지 품질
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:47'
labels: []
milestone: m-6
dependencies: []
type: task
ordinal: 96000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
잘못된 입력(--local 존재하지 않는 디렉토리, 잘못된 플래그), 네트워크 재시도, Ctrl-C 중단 시 나오는 메시지가 원인과 다음 행동(재실행하면 된다 등)을 명확히 전달하는지, 그리고 그 안내가 실제로 신뢰할 만한지(재실행이 정말 안전한지) 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
하위 3개(96.1-3) 전부 리뷰 완료. 96.2(영어/한국어 혼용)는 사용자 결정으로 전체 영어 통일 완료(commit 25db8ec). 96.1(에러 메시지 중복 문구)은 미수정 후보로 남김.
<!-- SECTION:NOTES:END -->
