---
id: TASK-147.2
title: 누락된 local 선언 적용
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 14:52'
labels: []
dependencies:
  - TASK-147.1
parent_task_id: TASK-147
type: task
ordinal: 220000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
147.1 스캔 결과에 local을 추가한다. docs/shell-style-guide.md 컨벤션(local 선언과 대입을
분리해야 하는 경우 - 명령 치환 결과를 담을 때)도 함께 지킨다. 순수 스코핑 수정이므로 동작이
바뀌면 안 된다 — 매 파일 수정 후 관련 shellspec으로 회귀 없음을 확인.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-147.1 스캔 결과(2개 파일, 3개 함수, 16건)에 local을 순수 스코핑 수정만으로 적용.

scripts/lint/check-hardcoded-paths.sh:
- is_allowlisted(): local file line list old_ifs entry entry_file entry_substr 추가
- check(): local label pattern allowlist file lineno content trimmed 추가
  (violations는 3회 호출에 걸쳐 누적되는 의도된 전역 카운터라 제외 — local을
  붙였다면 매 호출마다 리셋되어 마지막 exit 1 게이팅이 깨졌을 것)
- 명령치환(mktemp 등) 없는 단순 대입/파라미터 확장뿐이라 "local 선언 + 대입 분리"
  규칙이 걸리는 케이스는 없었음(원래도 분리돼 있던 코드에 local만 앞에 추가).

scripts/uninstall/01_uninstall_runtimes.sh:
- uninstall_from_config_file(): 기존 `local each_tool_tmp` 선언에 plugin version을
  합쳐 `local each_tool_tmp plugin version`으로 확장 (while read -r plugin version <&3).

검증(파일 단위 커밋마다):
- shellcheck -s sh: 신규 경고 0건(SC3043만 39→41건으로 정확히 +2, 새로 추가한 local
  선언 줄 수와 일치; SC1091/SC2034/SC2086/SC2155는 전후 동일).
- dash -n: 두 파일 모두 통과.
- check-hardcoded-paths.sh는 관련 shellspec이 없어 실제 실행으로 검증 — 정상 케이스
  (OK, exit 0)와 인위적 위반 케이스(/opt/homebrew, /usr/local 리터럴 2건 삽입 후
  정확히 2건 검출 + exit 1, violations 누적 정상)로 동작 불변 확인.
- spec/uninstall_runtimes_spec.sh: bash·dash 양쪽 4 examples 0 failures.
- 전체 shellspec 스위트: 수정 전(파일을 커밋 e40e5c6 버전으로 임시 교체)/후 모두
  bash 183 examples 0 failures, dash 183 examples 0 failures로 완전 동일 — 회귀 없음.

TASK-147 부모 포함 완료. 로컬 브랜치 task/TASK-147.1(스캔, final summary 포함),
task/TASK-147.2(이번 수정 2커밋) 생성, push는 하지 않음(정책).
<!-- SECTION:FINAL_SUMMARY:END -->
