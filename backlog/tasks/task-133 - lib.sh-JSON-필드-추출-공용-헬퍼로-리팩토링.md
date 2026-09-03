---
id: TASK-133
title: lib.sh JSON 필드 추출 공용 헬퍼로 리팩토링
status: Done
assignee: []
created_date: '2026-09-03 11:08'
updated_date: '2026-09-03 11:31'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lib.sh에 lt_json_field <key> [value_prefix] 공용 헬퍼를 추가하고
(lt_adoptium_arch 바로 뒤, lt_upstream_latest_version 정의 직전) lt_upstream_latest_version()
의 5개 브랜치(pnpm/gradle/golang/java/uv)에 중복돼 있던
grep -o '"FIELD"...' | head -1 | sed -E '...' 패턴을 각각 헬퍼 호출로 교체했다.

- pnpm/gradle: lt_json_field version (완전 동일 호출)
- golang: lt_json_field version go (value_prefix로 "go"를 매치+제거, 기존
  grep '"go[^"]*"' + sed 's/.../go(...)/'와 동일 동작)
- uv: lt_json_field tag_name
- java: semver 필드만 lt_json_field semver로 추출하고 "temurin-" 접두는 호출부에서
  printf로 처리(값에 접두를 붙이는 것은 입력 접두를 벗기는 것과 다른 연산이라 헬퍼
  시그니처를 오염시키지 않음). 값이 비어 있을 때 아무것도 출력하지 않는 원본 동작
  (빈 stdin에서 sed가 exit 0/무출력)도 if [ -n "$semver" ] 분기로 그대로 보존.
- java의 most_recent_lts 숫자 필드 추출(그 앞줄)은 따옴표로 감싼 문자열 필드가
  아니라 패턴이 달라 이번 리팩토링 대상 5곳에 포함하지 않았다(태스크 범위 그대로).

검증:
- shellcheck -s sh scripts/lib.sh: 새 코드에 새 경고/에러 없음(SC1087 오탐 1건은
  ${prefix}로 중괄호 처리해 해결, 나머지는 파일 전역에 이미 있던 SC3043 'local'
  경고와 동일 패턴).
- spec/lib_spec.sh 리팩토링 전/후 동일 결과: 94 examples, 0 failures
  (git stash로 원본 되돌려 재확인 후 pop).
- 전체 shellspec 스위트(리팩토링 후): 165 examples, 0 failures.
- 순수 리팩토링, 동작 변경 없음.

로컬 브랜치: task/TASK-133 (커밋만, push 안 함).
<!-- SECTION:FINAL_SUMMARY:END -->
