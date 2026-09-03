---
id: TASK-118.3
title: 방법별 비교표 작성 및 채택안 결정
status: To Do
assignee: []
created_date: '2026-08-30 11:41'
labels: []
dependencies:
  - TASK-118.1
  - TASK-118.2
parent_task_id: TASK-118
type: spike
ordinal: 144000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
118.1(저장소 메타데이터)과 118.2(asdf 자체 명령)의 조사 결과를 종합해 비교표를 만들고 이 저장소에 실제로 적용할 방법(또는 방법의 조합)을 결정한다.

비교 기준: 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 전체 커버리지, phase 0 타이밍 제약(00_select.sh:284-288) 대응 가능 여부, 네트워크 실패 시 폴백 난이도, 캐싱 용이성, 구현/유지보수 복잡도(이 저장소의 POSIX sh 스타일 유지 가능한지).

결정 결과는 Story 2(TASK-119)의 구현 범위를 확정하는 입력이 되므로, "왜 이 방법을 선택했는지"와 "기각한 방법의 사유"를 명확히 남긴다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 118.1/118.2에서 나온 모든 방법이 표 형태로 비교됨
- [ ] #2 채택 방법(또는 조합)이 결정되고 근거가 기록되어 TASK-119에서 참조 가능함
<!-- AC:END -->
