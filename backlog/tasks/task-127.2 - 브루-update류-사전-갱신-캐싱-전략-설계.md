---
id: TASK-127.2
title: 브루 update류 사전 갱신/캐싱 전략 설계
status: To Do
assignee: []
created_date: '2026-09-03 01:17'
labels: []
dependencies:
  - TASK-127.1
parent_task_id: TASK-127
type: task
ordinal: 172000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
목록을 언제 새로 고칠지(설치 스크립트 실행 시마다 / 별도 refresh 서브커맨드 / TTL 기반 캐시
파일) 설계한다. TASK-119.3(m-12)의 "네트워크 실패 시 .tool-versions 폴백" 로직과 이 캐싱
전략을 통합할지, 별도 캐시 계층을 둘지 결정한다. 캐시 저장 위치(예: $HOME 아래 report 파일과
같은 위치, TASK-107 패턴 참고)도 이 태스크에서 정한다.
<!-- SECTION:DESCRIPTION:END -->
