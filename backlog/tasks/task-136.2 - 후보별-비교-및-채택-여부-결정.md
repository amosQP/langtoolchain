---
id: TASK-136.2
title: 후보별 비교 및 채택 여부 결정
status: Done
assignee: []
created_date: '2026-09-03 11:31'
updated_date: '2026-09-04 20:02'
labels: []
dependencies:
  - TASK-136.1
references:
  - TASK-136.1
  - decision-13
parent_task_id: TASK-136
type: task
ordinal: 194000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
136.1 조사 결과를 표로 비교(POSIX sh 실질 커버리지, CI 통합 비용, 무료 사용 가능 여부,
유지보수 부담)하고 채택안을 결정한다. "지금 있는 shellcheck + 자체 lint로 충분하고 추가
도구는 불필요"라는 결론도 유효한 채택안이다. 결론은 backlog decision으로 기록한다. 채택
결론이 나오면 별도 구현(CI 통합) 태스크로 분리하고, 이 태스크 자체는 결정까지만 다룬다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
SonarQube Cloud(Free 플랜, public repo라 조건 충족)와 CodeQL(shell 전면 미지원)을 비교, CodeQL 기각 + SonarQube Cloud 채택으로 결정(decision-13). 셀프호스팅 Community Build는 shell 미지원이라 제외. 기존 shellcheck/자체 lint는 유지, SonarQube는 추가 레이어. CI 통합은 TASK-152로 분리.
<!-- SECTION:FINAL_SUMMARY:END -->
