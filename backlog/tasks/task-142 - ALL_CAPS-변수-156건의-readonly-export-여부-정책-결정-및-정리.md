---
id: TASK-142
title: ALL_CAPS 변수 156건의 readonly/export 여부 정책 결정 및 정리
status: To Do
assignee: []
created_date: '2026-09-03 22:28'
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
