---
id: TASK-127
title: 실 버전 목록 fetch를 위한 phase 순서/아키텍처 결정
status: Done
assignee: []
created_date: '2026-09-03 01:17'
updated_date: '2026-09-05 04:42'
labels: []
milestone: m-15
dependencies:
  - TASK-119
references:
  - decision-15
  - decision-16
priority: medium
type: task
ordinal: 170000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금 phase 0(00_select.sh)은 phase 1(asdf 부트스트랩)/phase 2(플러그인 설치)보다 먼저 실행돼서
`asdf list all <plugin>` 같은 실제 조회 수단이 아직 없다(00_select.sh:283-288 주석 참고). 이
Story는 "실제 설치 가능한 버전 목록"을 phase 0 시점(또는 그 전)에 조회할 수 있게 만드는
아키텍처를 결정한다.

검토할 선택지:
(a) plugin 설치(현재 phase 2)를 phase 0 이전으로 앞당겨서 asdf list-all을 쓸 수 있게 재배치
(b) TASK-118에서 채택한 방법이 저장소 메타데이터(git tags/Releases API 등) 기반이라면, asdf
    없이도 phase 0 시점에 목록을 가져올 수 있음 -- 이 경우 phase 재배치 없이 해결 가능

TASK-118.3(m-12)의 채택안 결정 결과를 그대로 가져와서 판단 근거로 쓸 것 -- 이 Story에서 그
조사를 반복하지 않는다.

brew update류의 "사전 갱신" 전략도 이 Story에서 설계한다: 목록을 언제 새로 고칠지(설치 시작
시 매번? 별도 refresh 명령? TTL 캐시?), 네트워크 실패 시 폴백을 TASK-119.3(m-12)의 기본값
폴백 로직과 통합할지 별도로 둘지 결정한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
127.1: phase 재배치 불필요 결정(decision-15) - 언어 공식 소스가 asdf 무관하게 phase 0에서 조회 가능함을 lib.sh 실측으로 확인. rust만 목록용 별도 소스 필요(TASK-128 위임). decision-12의 'asdf 미지원 버전' 갭은 이 결정으로 안 닫힘 - TASK-128/129에서 재검토 필요. 127.2: 버전 목록 캐싱을 기존 단일값 캐시와 분리하기로 결정(decision-16) - 별도 파일/함수, lazy 조회, 실패 시 기존 ask_version() 흐름 폴백.
<!-- SECTION:FINAL_SUMMARY:END -->
