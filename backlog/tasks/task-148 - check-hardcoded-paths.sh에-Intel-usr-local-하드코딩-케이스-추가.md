---
id: TASK-148
title: check-hardcoded-paths.sh에 Intel(/usr/local) 하드코딩 케이스 추가
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 13:56'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-125
  - TASK-61
priority: low
type: task
ordinal: 221000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: check-hardcoded-paths.sh(TASK-125)가 Homebrew prefix 하드코딩을
검사할 때 Apple Silicon 경로(/opt/homebrew)만 grep하고 Intel 경로(/usr/local)는 검사
안 한다. lt_homebrew_prefix()(scripts/lib.sh)는 두 경로를 대칭적으로 다루는데, 이 lint
도구는 그 절반만 커버한다 — TASK-61(Intel sqlite PATH 버그)과 정확히 반대되는 케이스가
재발해도 이 lint를 통과한다. /usr/local 하드코딩 패턴도 검사 대상에 추가.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
check-hardcoded-paths.sh의 Homebrew prefix 검사가 /opt/homebrew(Apple Silicon)만 grep하고 /usr/local(Intel)은 검사하지 않던 비대칭을 수정. HOMEBREW_PREFIX_ALLOWLIST에 lib.sh:57(lt_homebrew_prefix의 Intel 분기 정의부)을 추가하고, check() 패턴을 (/opt/homebrew|/usr/local)로 확장, 라벨/헤더 주석에 TASK-148과 두 아키텍처 모두 언급하도록 갱신. 기본 스캔 대상(install.sh, uninstall.sh, scripts/lib.sh, scripts/install/*.sh, scripts/uninstall/*.sh) 전체 재실행 결과 위반 0건. 의도적으로 제외된 spec/*.sh, scripts/lint/*.sh를 강제 포함한 저장소 전체 재실행에서는 예상대로 오탐이 나왔고(특히 spec/lib_spec.sh:178의 /usr/local/bin/fish), 이는 같은 파일의 기존 /opt/homebrew 오탐과 동일 범주(스펙이 리터럴 값을 테스트)라 hardcoded-paths-patterns.md에 문서화만 하고 코드 변경/별도 태스크는 만들지 않음. shellcheck 클린 확인.
<!-- SECTION:FINAL_SUMMARY:END -->
