---
id: TASK-60
title: shellspec 기반 자동 테스트 스위트 추가
status: Done
assignee: []
created_date: '2026-08-27 09:00'
labels:
  - code-quality
  - test
milestone: m-5
dependencies: []
priority: medium
type: chore
ordinal: 60000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
실기기 없이도 회귀를 잡을 수 있는 자동 테스트가 전혀 없었다. `brew install shellspec`(mocking을 내장한 bash 테스트 프레임워크)으로 `spec/` 스위트를 추가했다: `.shellspec`, `spec/spec_helper.sh`, `spec/lib_spec.sh`(`scripts/lib.sh`의 순수 함수 전부 — `version_core`, `binary_for_plugin`, `flag_for_binary`, `each_tool`, `detect_rc_file`, `read_scope`, `append_env_var`, `prepend_env_var`, `ensure_asdf_on_path`, `run`), `spec/validate_spec.sh`(TASK-53/57 회귀 테스트 + FAIL/DRY_RUN 케이스), `spec/install_plugins_spec.sh`(`grep -qx` 정확 매칭 가드), `spec/configure_shell_env_spec.sh`(brew shellenv가 asdf shim보다 rc 파일에서 먼저 오는지 + idempotency — TASK-18과 관련된 실제 프로덕션 버그였던 `f19057d`의 회귀 방지), `spec/select_spec.sh`(`00_select.sh`의 `--all`/`--local=DIR`/tty 없음 비대화형 경로). `shellspec` 전체 실행 결과 49개 예제 전부 통과.

주의: `brew`/`asdf`가 실제로 무엇을 설치했는지 자체를 검증하는 테스트(TASK-6/9/10/11/12/20 등)나, 진짜 사람이 터미널에서 타이핑하는 인터랙티브 분기(TASK-27/39)는 이 스위트가 대체하지 못한다 — mocking은 이 도구 자신의 오케스트레이션 로직(분기, 파싱, idempotency, PATH 순서)만 검증할 수 있고, "실제 시스템이 올바르게 바뀌었는가"는 여전히 실기기 검증 태스크의 몫이다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 `shellspec` 전체 스위트가 로컬에서 그린으로 통과한다
- [x] #2 TASK-53, TASK-57에서 고친 로직에 대한 회귀 테스트가 존재한다
- [x] #3 실기기/실제 패키지 설치가 필요한 태스크(TASK-6, 9-12, 20, 27, 39 등)는 이 스위트로 Done 처리하지 않는다
<!-- AC:END -->
