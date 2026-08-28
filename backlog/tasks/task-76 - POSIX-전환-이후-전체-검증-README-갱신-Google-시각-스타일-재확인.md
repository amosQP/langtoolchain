---
id: TASK-76
title: POSIX 전환 이후 전체 검증 + README 갱신 + Google 시각 스타일 재확인
status: Done
assignee: []
created_date: '2026-08-27 14:41'
updated_date: '2026-08-28 09:09'
labels:
  - code-quality
  - posix
milestone: m-5
dependencies:
  - TASK-75
priority: medium
type: chore
ordinal: 76000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-72~75 완료 후 마무리 작업: (1) 전체 파이프라인을 dash로 실제 dry-run 실행해서 최종 검증, (2) shellspec 스위트를 POSIX 셸 기준으로 최종 조정하고 전체 그린 확인, (3) README의 'bash 3.2 호환' 관련 서술을 POSIX sh 호환으로 갱신, (4) Google 시각적 스타일(들여쓰기 2칸/라인길이/네이밍)이 POSIX 전환 이후에도 유지되는지 재확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 전체 install/uninstall 파이프라인이 dash --dry-run으로 처음부터 끝까지 에러 없이 돈다
- [x] #2 shellspec 전체 그린
- [x] #3 README가 POSIX sh 호환을 정확히 반영한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:09
---
후속 감사(TASK-82)에서 이 태스크가 놓친 부분 발견: AC #3에서 'README가 POSIX sh 호환을 정확히 반영한다'고 체크했지만 설계 원칙 #2의 코드 예시가 여전히 제거된 bash 프로세스 치환을 보여주고 있어 원칙 #4와 모순됐음. TASK-82에서 수정.
---
<!-- COMMENTS:END -->
