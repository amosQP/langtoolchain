---
id: TASK-103
title: README 갱신 (동반 도구 설명)
status: Done
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:55'
labels: []
milestone: m-7
dependencies:
  - TASK-99
  - TASK-100
  - TASK-101
type: task
ordinal: 118000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
언어 목록/빠른 참조/설치 확인 섹션에 pnpm(nodejs 동반)/gradle(java 동반) 추가. 대화형 흐름 예시(transcript)에 동반 도구 질문 추가. rust/go에 동반 도구가 없는 이유(cargo/go tool 번들)도 간단히 언급.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
README 갱신 완료. '관리 범위' 섹션에 pnpm/gradle 추가 + rust/go에 동반 도구 없는 이유 설명. 겸사겸사 발견한 기존 부정확한 서술도 수정: '다른 언어의 asdf 플러그인은 전혀 안 건드림'이 uninstall의 실제 동작(asdf 전체를 지우면서 다른 plugin도 함께 삭제 - 02_remove_plugins.sh에 이미 의도적으로 문서화된 동작)과 모순되던 걸 'install 쪽에서는'으로 범위를 명확히 하고 uninstall 예외를 명시하는 경고 박스 추가. 빠른 참조/설치되는 것/파일시스템 명세 테이블/대화형 transcript 예시 전부 pnpm·gradle 반영, transcript에는 부모(java) 거절 시 동반 도구(gradle) 질문 자체가 안 뜨는 것도 실제 예시로 보여줌.
<!-- SECTION:NOTES:END -->
