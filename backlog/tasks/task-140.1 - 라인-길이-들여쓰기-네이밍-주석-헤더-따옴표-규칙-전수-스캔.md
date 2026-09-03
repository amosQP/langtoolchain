---
id: TASK-140.1
title: 라인 길이/들여쓰기/네이밍/주석 헤더/따옴표 규칙 전수 스캔
status: To Do
assignee: []
created_date: '2026-09-03 12:07'
labels: []
dependencies: []
parent_task_id: TASK-140
type: task
ordinal: 206000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/**/*.sh, install.sh, uninstall.sh, spec/**/*.sh 전체 대상으로 docs/shell-style-
guide.md의 규칙을 grep/awk 등으로 기계적으로 스캔 가능한 것부터 확인한다: 80자 초과 라인,
탭 문자 사용, 2칸이 아닌 들여쓰기, 함수/변수 네이밍(소문자+언더바 위반), 상수 네이밍
(대문자+언더바 위반 - 특히 최근 추가된 LT_* 상수들), 라이브러리 함수에 Globals/Arguments/
Outputs/Returns 헤더 주석이 없는 경우. 결과를 파일:라인 단위로 목록화한다.
<!-- SECTION:DESCRIPTION:END -->
