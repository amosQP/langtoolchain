---
id: TASK-118.2
title: 'asdf 자체 제공 명령(asdf latest, list-all) 기반 방법 조사'
status: Done
assignee: []
created_date: '2026-08-30 11:41'
updated_date: '2026-09-03 01:10'
labels: []
dependencies: []
parent_task_id: TASK-118
type: spike
ordinal: 143000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
asdf 자체가 제공하는 버전 조회 명령(asdf latest <plugin> [version], asdf list all <plugin>)을 이 저장소에서 실제로 쓸 수 있는지 재검토한다.

이미 00_select.sh:284-288에 "phase 0에서 list-all을 쓰지 않은 이유"가 문서화돼 있음 — 이 태스크는 그 판단을 뒤집는 게 아니라, "phase 0가 아닌 다른 시점"이나 "캐싱 결합"으로 asdf 자체 명령을 여전히 활용할 수 있는지 조사한다. 예: 플러그인이 이미 설치된 이후 시점(phase 2 이후)에 한 번 조회해서 다음 실행부터 기본값으로 캐싱하는 방식이 가능한지.

asdf latest는 list-all보다 가벼울 수 있음(단일 최신값만 반환) — 이것이 phase 0 제약을 완화할 수 있는지도 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 asdf latest / asdf list all 각각의 실행 비용(네트워크 호출 여부, 소요 시간 실측)이 기록됨
- [x] #2 phase 0 제약(00_select.sh:284-288)을 우회할 수 있는 실행 시점 또는 캐싱 조합이 최소 1개 이상 제안됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
2026-09-03 실측 (이 개발 머신, 플러그인 7개 모두 이미 설치돼 있는 상태에서 측정 -
end-user의 phase 0 시점 상태와는 다름, 아래 참고):

실행 비용(플러그인이 이미 설치돼 있다는 전제하):
- asdf latest nodejs -> 26.8.1, ~1.6s (네트워크 호출 있음)
- asdf latest pnpm -> 12.3.1, ~0.8s
- asdf latest rust -> 1.98.0, ~0.7s
- asdf latest golang -> 1.27.1, ~1.7s
- asdf latest java (쿼리 없이) -> 실패("No compatible versions available") - 기본
  쿼리로는 매치 안 됨. "temurin-" 쿼리를 줘도 "temurin-jre-26.0.2+101"(JRE)이 나와
  JDK가 아님 - 쿼리 튜닝이 java 플러그인 자체의 네이밍 규칙(JRE/JDK가 접두어로만
  구분 안 됨) 때문에 까다로움.
- asdf latest gradle (쿼리 없음) -> 실패, list-all 결과에 정식 릴리스와 rc/milestone이
  섞여 있어 별도 필터링 필요 (services.gradle.org API 쪽이 훨씬 단순함, 118.1 참고).
- asdf latest python "3." -> "3.14.7t" 반환 - "t"(free-threaded 빌드)가 일반
  "3.14.7"보다 사전식으로 더 크다고 판단되어 선택됨. 이 저장소의 기존
  .tool-versions 관례(순수 "3.12.13")와 다른 값이 나오는 실제 함정 확인.
- asdf list all nodejs -> 864개 버전, ~0.76s.

phase 0 제약(00_select.sh:284-288) 재검토:
- 위 모든 명령은 "플러그인이 이미 asdf에 추가돼 있다"는 전제에서만 동작한다.
  fresh 설치(00_select.sh가 실제로 실행되는 최초 실행 시나리오)에서는 플러그인이
  하나도 없으므로 `asdf latest <plugin>`/`asdf list all <plugin>` 모두 즉시 에러남.
  이건 기존 주석이 지적한 문제 그대로 - 이번 조사로 뒤집히지 않음.
- 우회 후보로 제안됐던 "플러그인 설치 후(phase 2 이후) 시점에 조회해 다음 실행부터
  캐싱": 실행 가능하긴 하나, 이번 설치 세션 자체의 메뉴에는 반영이 안 되고(그
  세션에서는 이미 정적값으로 메뉴가 다 지나간 뒤), 오직 "다음 번" 실행에만
  득이 됨 - 이는 이 마일스톤이 원하는 "설치 시점에 최신값을 물어봄"이라는 목표를
  달성 못 함. 게다가 phase 2 이후 시점에서 값을 얻어도 그 값을 다시 phase 0의
  메뉴(00_select.sh)로 되돌려주려면 여러 phase 스크립트에 걸친 상태 전달 구조가
  새로 필요함 - 이 마일스톤 범위를 벗어나는 아키텍처 변경.
- asdf latest가 list-all보다 가벼운 것(단일 값)은 맞지만("temurin-jre-..." 같은
  오답 사례에서 보듯) 언어별 쿼리 튜닝이 필요해 안정성이 떨어지고, 플러그인
  미설치라는 근본 제약은 그대로 남음 - phase 0 제약을 "완화"하지 못함.

결론(요약, 118.3에서 최종 결정): asdf 자체 명령은 "플러그인이 이미 있어야 한다"는
근본 제약을 이번 조사로도 우회할 방법을 찾지 못함. 118.1의 저장소 메타데이터
방식은 이 제약 자체가 없어(asdf도 플러그인도 불필요) phase 0에서 바로 쓸 수 있음.
<!-- SECTION:NOTES:END -->
