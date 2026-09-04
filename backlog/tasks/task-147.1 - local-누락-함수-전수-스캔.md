---
id: TASK-147.1
title: local 누락 함수 전수 스캔
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 14:38'
labels: []
dependencies: []
parent_task_id: TASK-147
type: task
ordinal: 219000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/**/*.sh, install.sh, uninstall.sh 전체에서 함수 정의를 찾아, 함수 안에서 처음
쓰이는(대입되는) 변수인데 local 선언 없이 바로 쓰인 경우를 찾는다. 이미 전역 상수/전역
상태로 의도된 것(TASK-142가 이미 분류해둔 ALL_CAPS 전역들)은 제외 — 함수 안에서만 쓰는
소문자 임시 변수 중심으로 스캔. 결과를 파일:라인:함수명:변수명 단위로 목록화.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/**/*.sh, install.sh, uninstall.sh 전체(함수 정의 59개, log/step/die/tty_out/tty_prompt
같은 한 줄짜리 트리비얼 함수 5개 제외)를 함수별로 스캔. scripts/install/02~06, uninstall/02~06
phase 스크립트는 함수 정의가 아예 없어 전량 스크립트 최상위(의도적 전역) 스코프 — 대상 아님.

발견 (2개 파일, 3개 함수, 16건, 모두 local 없이 첫 대입):

scripts/lint/check-hardcoded-paths.sh (TASK-125.3, m-14 — 이번 태스크의 계기가 된 파일):
- is_allowlisted() [62-72행]: file, line, list, old_ifs, entry(for), entry_file, entry_substr (7건)
- check() [85-95행]: label, pattern, allowlist, file(for), lineno(read), content(read), trimmed (7건)
  - 예외: 같은 함수의 violations(103행)는 local 대상 아님 — 함수 밖(최상위)에서
    violations=0으로 초기화된 뒤 check()가 3번 호출되며 누적되는 의도된 전역 카운터.
    local을 붙이면 매 호출마다 리셋되어 마지막 exit 1 게이팅이 깨짐(동작 변경 금지 위반).

scripts/uninstall/01_uninstall_runtimes.sh:
- uninstall_from_config_file() [57행]: while read -r plugin version <&3 — plugin, version (2건)

스캔 방법: 함수 본문을 브레이스 깊이로 추적하는 파이썬 스크립트로 1차 자동 후보 추출
(대입문/for/read 3패턴, ALL_CAPS 전역 제외) 후 lib.sh(local 24회+, 이제 34개 함수 전부
선두에 local 일괄 선언 스타일 확인)와 00_select.sh의 복잡한 함수(lt_arrow_menu 등),
install.sh/uninstall.sh의 clone_fetch_with_timeout 등을 직접 읽고 교차검증 — 위 2개 파일
외에는 기존 관례(local x y z 형태로 함수 선두 일괄 선언, 명령치환 대입은 TASK-71/143 헤더
컨벤션대로 선언과 대입 분리)가 이미 전부 지켜지고 있음을 확인.
<!-- SECTION:FINAL_SUMMARY:END -->
