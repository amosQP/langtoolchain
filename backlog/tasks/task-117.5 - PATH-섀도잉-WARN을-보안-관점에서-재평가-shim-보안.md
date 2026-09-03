---
id: TASK-117.5
title: PATH 섀도잉 WARN을 보안 관점에서 재평가 (shim 보안)
status: Done
assignee: []
created_date: '2026-08-30 11:34'
updated_date: '2026-09-03 01:25'
labels: []
dependencies: []
references:
  - decision-3
documentation:
  - docs/download-points-inventory.md
parent_task_id: TASK-117
type: task
ordinal: 139000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/07_validate.sh:46-57는 resolved 바이너리 경로가 $ASDF_DATA_DIR/shims/ 밑에 있는지 확인하고, 다른 곳(시스템 전역 설치 등)이 먼저 잡히면 WARN만 하고 FAIL하지 않는다 (TASK-57에서 다룬 로직과 연관, 그 태스크는 ASDF_DATA_DIR 커스텀 설정 인식 버그를 고친 것이지 WARN/FAIL 정책 자체를 바꾼 게 아님).

"shim 보안" 관점에서 이는 PATH 우선순위 공격 표면이다: 악의적이거나 손상된 바이너리가 asdf shim보다 먼저 PATH에서 잡혀도 설치는 "성공"으로 끝난다. 이 저장소엔 shim 자체를 생성/서명하는 코드가 없으므로(asdf에 위임), 이 저장소가 통제할 수 있는 유일한 shim 관련 보안 지점이 바로 이 검증 단계다.

검토할 것: WARN을 FAIL로 격상할지(사용자 기존 PATH 설정과 충돌해 false positive 늘어날 위험 vs 보안), 아니면 WARN 유지하되 메시지에 보안 함의를 명시할지 결정.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 07_validate.sh의 PATH 섀도잉 체크에 대해 WARN 유지/FAIL 격상 여부가 결정되고 근거가 기록됨
- [x] #2 결정에 따라 코드 또는 경고 메시지가 갱신됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
decision-3으로 WARN 유지(FAIL 미격상) 결정: 동명 바이너리가 PATH 앞쪽에서 잡히는 상황은 흔하고 대체로 무해해 FAIL 격상 시 오탐이 실제 탐지보다 많아짐, 이미 타협된 시스템에서 install 단계 FAIL 하나로 막을 수 있는 위협도 아님, decision-1의 스코프 원칙과도 일관. 07_validate.sh의 WARN 메시지를 '이 설치기가 검증한 범위 밖'이라는 함의가 드러나도록 보강. shellcheck(기존 SC1091/SC3043 외 신규 없음)/dash -n/shellspec(132/132) 통과.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
PATH 섀도잉 WARN을 FAIL로 격상하지 않기로 결정(decision-3) — 흔하고 대체로 무해한 상황에 대한 오탐 위험이 실제 보안 이득보다 큼. 대신 경고 메시지를 '이 설치기가 검증/설정한 바이너리가 아니다'라는 함의가 드러나도록 보강. shellcheck/dash -n/shellspec(132/132) 통과.
<!-- SECTION:FINAL_SUMMARY:END -->
