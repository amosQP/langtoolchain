---
id: TASK-113
title: main.sh 2개 파일 함수 분리 (언어선택/확인프롬프트)
status: Done
assignee: []
created_date: '2026-08-30 05:01'
updated_date: '2026-08-30 05:10'
labels: []
dependencies: []
type: task
ordinal: 128000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install/main.sh의 run_language_selection() 추출, uninstall/main.sh의 confirm_uninstall() 추출 - 사용자에게 before/after 원문 보여주고 둘 다 승인받음.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
run_language_selection()(install/main.sh), confirm_uninstall()(uninstall/main.sh) 추출 완료. 검증 중 confirm_uninstall()의 set -e 버그(A && return / A || return 단독문이 좌변 실패 시 스크립트 전체를 조용히 종료시킴) 발견, if-then 형태로 수정. shellcheck(sh/dash) 및 shellspec 132/132(sh, dash) 통과, 실사용 경로(--dry-run, --dry-run --yes/--all) 재검증 완료.
<!-- SECTION:NOTES:END -->
