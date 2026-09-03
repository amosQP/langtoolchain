---
id: TASK-142
title: ALL_CAPS 변수 156건의 readonly/export 여부 정책 결정 및 정리
status: Done
assignee: []
created_date: '2026-09-03 22:28'
updated_date: '2026-09-03 22:55'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-140
documentation:
  - docs/shell-style-guide.md
priority: low
type: chore
ordinal: 209000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-140.1 스캔 결과: docs/shell-style-guide.md의 '상수/환경변수는 대문자+언더바이고 선언 즉시 readonly/export' 규칙 기준으로, ALL_CAPS 이름으로 대입되면서도 readonly/export 없이 선언된 변수가 39개 대상 파일 전반에 걸쳐 156건 발견됨(SCRIPT_DIR/REPO_ROOT/CONFIG_FILE 같은 phase 스크립트의 준-전역 변수 패턴이 대부분).

TASK-140.2에서 '광범위하고 구조적'으로 분류해 직접 수정하지 않음 — 기계적으로 readonly를 붙이면 안 되는 이유: 상당수(SCOPE, SUCCESS, FAILED, CLONE_ATTEMPT, SCOPE_DIR 등)는 스크립트 실행 중 실제로 재대입되는 진짜 가변 상태라 readonly를 걸면 스크립트가 깨짐. 반면 SCRIPT_DIR/REPO_ROOT/CONFIG_FILE류는 한 번 설정되면 안 바뀌는 진짜 상수라 readonly 후보임. 즉 156건을 '상수(readonly 대상)'와 '가변 전역 상태(그대로 두거나 네이밍 컨벤션을 별도로 정의)'로 나누는 정책 판단이 선행되어야 하고, 그 자체가 이 감사(TASK-140)의 스코프인 순수 스타일 국소 수정을 벗어남.

권장 접근: (1) 156건을 변수별로 '재대입 여부'로 1차 분류(grep으로 같은 스크립트 내 동일 변수명 재대입 여부 확인 가능), (2) 진짜 상수는 readonly 추가, (3) 진짜 가변 전역 상태는 docs/shell-style-guide.md에 '스크립트 전역 상태 변수도 ALL_CAPS를 쓰되 readonly는 강제하지 않는다'는 예외 규칙을 명문화할지 팀 결정 필요. 위반 목록(파일:라인:변수명)은 이 태스크를 맡는 세션에서 재현 가능(readonly/export가 없는 최상위 ALL_CAPS= 대입을 grep).
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
156건 전수 분류 완료. 기준: (1) 선언 이후 같은 변수명 재대입문이 파일에 없고, (2) 루프/함수 본문 안이 아니며(있으면 반복마다 재실행되어 readonly 시 2회차에 깨짐), (3) 명령 접두사 환경변수 오버라이드(FOO=bar cmd)가 아닌 경우만 '진짜 상수'로 분류해 readonly 추가. 결과: readonly 71건 추가(SCRIPT_DIR/REPO_ROOT/CONFIG_FILE류 준-전역 경로 변수, HOMEBREW_INSTALL_* 등 리터럴 상수, uninstall/01의 if/elif/else 3-way CONFIG_FILE 포함) — install.sh/uninstall.sh 각 5, scripts/lib.sh 8(LT_BUILD_DEPS 등 오버라이드 아닌 순수 상수만), 나머지는 install/uninstall 각 phase 스크립트. 가변 전역 상태로 남긴 것 48건(SCOPE/SCOPE_DIR/SUCCESS/FAILED/OK/DRY_RUN/CLONE_ATTEMPT/LT_CHILD_PID/IFS 등 재대입·루프-내-대입·오버라이드-설계 변수, LT_LOCK_DIR류 ${VAR:-default} 오버라이드 상수 6개 포함) + 명령 접두사 환경변수 오버라이드 1건(NONINTERACTIVE, 대상 아님) + spec/*.sh 36건(SCRIPT 등, Describe 블록 재사용으로 readonly 시 실제로 깨짐을 main_entrypoints_spec.sh에서 확인해 전부 제외) = 71+48+1+36=156 정합. docs/shell-style-guide.md 네이밍 규칙에 예외 규칙 추가: ALL_CAPS가 곧 상수가 아니라는 것, 판단 기준(재대입/루프/오버라이드/명령-접두사), LT_LOCK_DIR류 오버라이드 패턴 및 IFS 저장/복원 패턴을 readonly 대상에서 제외하는 이유를 명문화. shellcheck -s sh: 수정 22개 파일 전후 경고 수 동일(58건, 전부 기존 SC3043/SC1091/SC2034/SC2155/SC2086 베이스라인, 신규 경고 0건). shellspec: bash/dash 양쪽 177 examples 0 failures로 변경 전후 동일. install.sh/uninstall.sh를 실제 실행하지 않고 shellcheck+dash -n+shellspec으로만 검증.
<!-- SECTION:FINAL_SUMMARY:END -->
