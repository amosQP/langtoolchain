---
id: TASK-55
title: 00_select.sh 대화형 로컬 스코프 프롬프트에서 잘못된 디렉토리 입력 시 임시파일 누수
status: Done
assignee: []
created_date: '2026-08-24 13:03'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - scripts/install/00_select.sh
priority: low
type: bug
ordinal: 55000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
대화형 흐름에서 로컬 스코프 디렉토리로 존재하지 않는 경로를 입력하면 die()가 호출되는데, 이 시점엔 이미 언어 선택이 OUT_FILE에 기록되어 있어(비어있지 않음) 기존 'emptiness 기반' cleanup trap이 이걸 정상 핸드오프로 착각해 삭제하지 않았다. SUCCESS 플래그를 도입해 실제 echo "$OUT_FILE" 성공 시점에만 true로 설정하도록 수정, 모킹으로 재현/검증.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 die()로 종료되는 모든 경로에서 OUT_FILE이 내용 유무와 무관하게 정리된다
- [ ] #2 정상 종료(echo "$OUT_FILE") 경로는 그대로 파일이 보존된다
<!-- AC:END -->
