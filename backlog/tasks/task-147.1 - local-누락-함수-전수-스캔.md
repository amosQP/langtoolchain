---
id: TASK-147.1
title: local 누락 함수 전수 스캔
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
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
