---
id: TASK-119.1
title: lib.sh에 버전 조회 헬퍼 추가 (case-dispatch 스타일)
status: Done
assignee: []
created_date: '2026-08-30 11:41'
updated_date: '2026-09-03 11:27'
labels: []
dependencies: []
parent_task_id: TASK-119
type: task
ordinal: 145000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Story 1(TASK-118.3) 채택안에 따라 scripts/lib.sh에 언어별 최신/기본 버전 조회 헬퍼를 추가한다 (예: lt_upstream_latest_version <plugin>).

기존 코드 스타일 준수: lib.sh:542-572 binary_for_plugin()/lt_companion_for_plugin()이 연관 배열 대신 언어별 case 분기를 쓰는 이유는 bash 3.2/POSIX sh 호환 유지 때문(TASK-71/72 POSIX 전환 정책과 동일 맥락) — 새 헬퍼도 이 패턴을 따른다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 scripts/lib.sh에 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 전부를 처리하는 버전 조회 헬퍼 함수가 추가됨
- [x] #2 shellcheck 통과 (POSIX sh 준수)
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
scripts/lib.sh에 lt_upstream_latest_version <plugin> 추가 (decision-4의 언어별
소스 표 그대로 구현). binary_for_plugin()/lt_companion_for_plugin()과 동일한
case-dispatch 스타일. 7개 언어 전부 처리:
- nodejs: 네트워크 호출 없이 "lts" 그대로 통과 (asdf가 install 시점에 직접 해석)
- pnpm/gradle/golang/rust: curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" +
  grep/sed/awk로 필드 추출 (jq/python 등 이 저장소가 전제하지 않는 도구 미사용)
- python: git ls-remote --tags cpython + 정규식 필터(prerelease 제외) + 필드별
  숫자 정렬(macOS BSD sort -V 미지원 우회)
- java: adoptium API 2단계 호출(최신 LTS major 확인 -> 그 major의 GA 빌드 semver),
  temurin- 접두어 부여

실패 시 항상 return 1(아무 출력 없음) - 호출자가 폴백을 갖는다는 전제(TASK-119.3).
curl 부재/네트워크 실패는 각 case 내부의 `|| return 1`이 그대로 처리 - 별도의
상단 `command -v curl` 가드는 두지 않음(nodejs/python 브랜치를 잘못 막는 문제가
있어 제거).

테스트: spec/lib_spec.sh에 Describe 'lt_upstream_latest_version()' 10개 케이스
추가 - curl/git 전부 shellspec Mock으로 대체(실 네트워크 호출 없음). TASK-118
연구 중 실측한 실제 API 응답 형태를 축약한 fixture 사용. 7개 언어 정상 케이스,
unknown plugin 실패, curl 1차/2차(java) 실패 케이스 포함.

shellspec spec/lib_spec.sh: 78 examples, 0 failures.
shellcheck -s sh scripts/lib.sh: 기존에도 있던 SC3043(POSIX sh에 local 없음 -
이 저장소가 의도적으로 허용하는 예외, 파일 헤더 코멘트 참고) 외 신규 경고 없음.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lib.sh에 lt_upstream_latest_version() 추가 — decision-4에서 채택한 언어별 소스를 binary_for_plugin()/lt_companion_for_plugin()과 동일한 case-dispatch 스타일로 구현. 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 전부 처리하며, nodejs는 네트워크 호출 없이 lts를 그대로 통과, pnpm/gradle/golang/rust는 curl --max-time+grep/sed/awk, python은 git ls-remote --tags+정규식 필터+숫자정렬, java는 adoptium API 2단계 호출로 구현. 실패 시 항상 return 1(무출력)로 통일해 호출자(TASK-119.3)의 폴백을 전제로 함. spec/lib_spec.sh에 curl/git을 전부 shellspec mock으로 대체한 10개 케이스 추가, 전체 스위트 78 examples 0 failures, shellcheck -s sh 신규 경고 없음(기존 허용 SC3043 제외).
<!-- SECTION:FINAL_SUMMARY:END -->
