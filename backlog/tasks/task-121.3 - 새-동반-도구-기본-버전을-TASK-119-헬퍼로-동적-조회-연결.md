---
id: TASK-121.3
title: 새 동반 도구 기본 버전을 TASK-119 헬퍼로 동적 조회 연결
status: Done
assignee: []
created_date: '2026-08-30 12:01'
updated_date: '2026-09-03 01:29'
labels: []
dependencies:
  - TASK-121.2
  - TASK-119
parent_task_id: TASK-121
type: task
ordinal: 160000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-119(선택된 기본값 조회 방법 구현)에서 만든 버전 조회 헬퍼(예: lt_upstream_latest_version)가 121.2에서 추가한 새 동반 도구에도 적용되도록 연결한다. m-12가 목표하는 "정적 하드코딩 대신 동적 기본값"이 기존 7개 언어뿐 아니라 새로 추가되는 동반 도구에도 일관되게 적용되어야 함.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 새 동반 도구의 기본 버전도 TASK-119 헬퍼를 통해 동적으로 조회됨(정적 .tool-versions 값에만 의존하지 않음)
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lib.sh: lt_upstream_latest_version()에 uv) 케이스 추가 - decision-5 Consequences에
예정된 대로 GitHub Releases API(api.github.com/repos/astral-sh/uv/releases/latest)
사용, tag_name 필드가 이미 asdf-uv 버전 문자열과 그대로 일치(v접두어 없음)해
별도 변환 불필요.

이로써 python 동반 도구 uv도 나머지 7개 언어와 완전히 동일한 경로(캐시 ->
lt_upstream_latest_version -> .tool-versions 폴백)로 00_select.sh의
lt_offer_language()에서 동적 조회됨 - 별도 통합 코드 불필요(TASK-119.2의
companion 처리 루프가 lt_companion_for_plugin()이 반환하는 이름을 그대로
lt_resolve_default_version에 넘기므로, uv가 그 목록에 들어간 순간 자동으로
같은 경로를 탐).

테스트: spec/lib_spec.sh에 (1) lt_upstream_latest_version uv 단위 테스트,
(2) lt_resolve_default_version uv 종단 테스트(캐시 기록까지 확인) 추가.

전체 스위트: shellspec (spec/ 전체) 151 examples, 0 failures.
shellcheck -s sh scripts/lib.sh: 신규 경고 없음.
<!-- SECTION:NOTES:END -->
