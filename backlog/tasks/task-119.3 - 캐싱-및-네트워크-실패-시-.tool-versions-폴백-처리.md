---
id: TASK-119.3
title: 캐싱 및 네트워크 실패 시 .tool-versions 폴백 처리
status: Done
assignee: []
created_date: '2026-08-30 11:41'
updated_date: '2026-09-03 11:27'
labels: []
dependencies:
  - TASK-119.2
parent_task_id: TASK-119
type: task
ordinal: 147000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
동적 버전 조회가 실패(오프라인, API rate limit, 타임아웃)했을 때 설치 흐름이 멈추지 않도록 기존 .tool-versions 정적 값으로 폴백한다. 반복 실행 시 매번 네트워크 조회하지 않도록 캐싱(예: $HOME 하위 캐시 파일, TTL)도 함께 처리.

관련 기존 패턴: scripts/lib.sh의 retry()(212) — 네트워크 재시도 자체는 이미 있는 패턴이므로 재사용 검토. lt_report(설치 리포트 기록, TASK-107) 위치도 캐시 파일 배치 시 참고.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 네트워크 조회 실패 시 .tool-versions 값으로 자동 폴백되고 설치가 중단되지 않음
- [x] #2 짧은 시간 내 재실행 시 캐시된 값을 재사용해 불필요한 네트워크 조회를 피함
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lib.sh에 캐싱 계층 추가 (lt_resolve_default_version을 확장):
- LT_VERSION_CACHE_FILE(기본 $HOME/.langtoolchain-version-cache, override 가능) /
  LT_VERSION_CACHE_TTL(기본 86400초=24h, override 가능) - LT_LOCK_DIR/LT_REPORT_FILE과
  동일한 override 패턴.
- lt_cached_version_lookup <plugin>: 캐시 파일에서 TTL 이내의 값 조회 (miss/stale는
  return 1). 캐시 라인 포맷은 lt_env_var_defs()가 이미 쓰는 "|||" 트리플파이프
  구분자 재사용("<plugin>|||<epoch>|||<version>").
- lt_cache_version <plugin> <version>: 해당 plugin 라인만 교체(다른 plugin 라인은
  보존), (over)write.
- lt_resolve_default_version: 캐시 우선(네트워크 호출 없음) -> 없거나 만료 시
  lt_upstream_latest_version 실 조회 -> 성공 시 캐시에 기록 -> 실패 시(오프라인/
  rate limit/타임아웃/미매핑 플러그인 전부 포함) static-default(.tool-versions
  값)로 폴백, 절대 빈 값을 반환하지 않음 - 설치 흐름이 중단되지 않음.

기존 retry()(lib.sh:212)는 재사용하지 않기로 결정 - 대상이 "일시적 네트워크
실패를 같은 호출 안에서 재시도"인데, 이 헬퍼가 필요한 건 그것보다 "세션 간
캐싱으로 애초에 재호출 자체를 피하는 것"이라 성격이 다름. lt_upstream_latest_version
내부 각 curl/git 호출 자체의 안정성은 --max-time/http.lowSpeedTime(TASK-119.1)로
이미 다뤘음.

테스트: spec/lib_spec.sh Describe 'lt_resolve_default_version()'을 7케이스로
확장(기존 4 + 캐시 히트/TTL 만료/다른 plugin 캐시 보존 3개 신규). 전부
LT_VERSION_CACHE_FILE을 mktemp 스크래치 파일로 돌려 실제 $HOME을 절대 건드리지
않음(테스트 전후 $HOME/.langtoolchain-version-cache 미생성 확인).

전체 스위트: shellspec (spec/ 전체) 149 examples, 0 failures.
shellcheck -s sh scripts/lib.sh: 기존 허용된 SC3043 외 신규 경고 없음.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
lt_resolve_default_version()에 캐싱+오프라인 폴백 계층 추가. LT_VERSION_CACHE_FILE(기본 $HOME/.langtoolchain-version-cache)/LT_VERSION_CACHE_TTL(기본 24h, 둘 다 override 가능) 도입, 캐시 우선 조회(네트워크 호출 없음) -> 만료/미스 시 lt_upstream_latest_version 실조회 -> 성공 시 캐시 기록 -> 실패(오프라인/rate limit/타임아웃/미매핑 플러그인 전부 포함) 시 .tool-versions 정적값으로 폴백해 절대 빈 값을 반환하지 않고 설치 흐름이 중단되지 않게 함. 기존 retry()(lib.sh:212)는 목적이 달라(같은 호출 내 재시도 vs 세션간 캐싱으로 재호출 자체 회피) 재사용하지 않기로 결정. spec/lib_spec.sh를 7케이스로 확장(캐시 히트/TTL 만료/plugin별 캐시 보존 신규 3개), 실제 $HOME 미오염 확인. 전체 스위트(spec/ 전체) 149 examples 0 failures, shellcheck 신규 경고 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
