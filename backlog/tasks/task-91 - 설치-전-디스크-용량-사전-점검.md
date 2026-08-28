---
id: TASK-91
title: 설치 전 디스크 용량 사전 점검
status: Done
assignee: []
created_date: '2026-08-28 10:02'
updated_date: '2026-08-28 10:10'
labels:
  - feature
  - shell
milestone: m-2
dependencies: []
priority: medium
type: feature
ordinal: 91000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
컴파일 도중 디스크 부족으로 실패하는 걸 사전에 걸러주는 로직이 없다. lib.sh에 ensure_disk_space(min_gb) 추가(df -Pk로 확인), install/main.sh가 언어 선택 프롬프트 띄우기 전에 5GB 기준으로 호출. DRY_RUN이면 스킵(미리보기 목적 방해 안 하려고).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 여유 공간이 기준 미만이면 언어 선택 프롬프트 전에 명확한 에러로 즉시 종료한다
- [x] #2 DRY_RUN에서는 스킵된다
- [x] #3 shellspec 회귀 테스트 추가
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 10:10
---
lib.sh에 ensure_disk_space(min_gb) 추가(df -Pk 파싱), install/main.sh가 언어 선택 프롬프트 전에 5GB 기준으로 호출(DRY_RUN이면 스킵). shellspec으로 df를 Mock해서 임계값 위/아래 분기 모두 검증(die() 경로는 서브프로세스로), 실제 dry-run에서 정상 통과 확인. 88/88(bash+dash) 통과.
---
<!-- COMMENTS:END -->
