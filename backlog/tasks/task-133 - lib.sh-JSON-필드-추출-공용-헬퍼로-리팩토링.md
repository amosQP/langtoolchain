---
id: TASK-133
title: lib.sh JSON 필드 추출 공용 헬퍼로 리팩토링
status: To Do
assignee: []
created_date: '2026-09-03 11:08'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-119.1
priority: low
type: task
ordinal: 189000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: lt_upstream_latest_version()의
grep -o '"FIELD"...' | head -1 | sed -E 's/.*"([^"]*)"$/\1/' 패턴이 pnpm/gradle/golang/
java/uv 5개 브랜치(scripts/lib.sh 약 744~797행대)에 거의 그대로 중복됨(pnpm/gradle은
byte-for-byte 동일, golang/java는 prefix 변형).

lt_json_field <key> [prefix] 같은 공용 헬퍼로 추출해서 5곳을 각각 그 헬퍼 호출로 교체한다.
순수 리팩토링 — 동작 변경 없음. 기존 shellspec(특히 lt_upstream_latest_version 관련 테스트,
spec/lib_spec.sh)이 리팩토링 전후로 동일하게 통과하는지로 회귀를 확인한다.
<!-- SECTION:DESCRIPTION:END -->
