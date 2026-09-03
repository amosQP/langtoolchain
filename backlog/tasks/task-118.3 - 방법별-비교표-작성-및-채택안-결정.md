---
id: TASK-118.3
title: 방법별 비교표 작성 및 채택안 결정
status: Done
assignee: []
created_date: '2026-08-30 11:41'
updated_date: '2026-09-03 01:12'
labels: []
dependencies:
  - TASK-118.1
  - TASK-118.2
references:
  - decision-1
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
- [x] #1 118.1/118.2에서 나온 모든 방법이 표 형태로 비교됨
- [x] #2 채택 방법(또는 조합)이 결정되고 근거가 기록되어 TASK-119에서 참조 가능함
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
비교표 및 채택안 결정: decision-1 참고 ("언어 버전 기본값 조회: 저장소 공식
메타데이터/API 채택").

요약: TASK-118.1(저장소 메타데이터) 채택, TASK-118.2(asdf 자체 명령) 기각.

기각 사유(asdf 자체 명령): 플러그인 미설치 상태에서 즉시 실패 - 00_select.sh
phase 0 시점엔 asdf 플러그인이 하나도 없다는 게 근본 제약이며, 이번 조사에서도
그 제약을 실질적으로 우회할 방법을 찾지 못함(phase 2 이후로 옮기는 방안은
"다음 실행"에만 도움되고 이번 세션 메뉴엔 반영 안 됨 + phase간 상태 전달 구조
신설 필요 - 마일스톤 범위 밖). 또한 java/gradle은 기본 쿼리로 매치 실패, python은
free-threaded 빌드("3.14.7t")가 섞여 나오는 함정도 실측 확인.

채택 사유(저장소 메타데이터): asdf/플러그인 상태와 무관하게 동작해 phase 0
제약 자체가 적용되지 않음, 7개 언어 전체 커버리지 확인, 인증/rate limit
부담 없음(GitHub API 미사용), 응답속도 전부 1초 미만, 실패 시 폴백이
`|| return 1` 패턴 하나로 단순.

TASK-119(구현)에서 참조할 언어별 소스는 decision-1 표 참고.
<!-- SECTION:NOTES:END -->
