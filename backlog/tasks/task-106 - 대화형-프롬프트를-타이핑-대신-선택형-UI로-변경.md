---
id: TASK-106
title: 대화형 프롬프트를 타이핑 대신 선택형 UI로 변경
status: To Do
assignee: []
created_date: '2026-08-30 03:48'
labels: []
milestone: m-10
dependencies: []
type: task
ordinal: 121000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금은 00_select.sh가 Y/n과 버전 문자열을 전부 직접 타이핑하게 함. 사용자가 실제 설치 테스트하면서 '입력 말고 선택하게 해달라'고 요청 — 번호 매긴 목록에서 숫자 입력, 또는 방향키 메뉴 등 POSIX sh로 구현 가능한 선택 UI 설계 필요. 버전 목록은 'asdf list all <plugin>'로 실제 조회 가능한 후보를 보여주는 방향 고려. 방향키 메뉴는 POSIX sh에서 raw 모드 키 입력 처리가 까다로워 구현 난이도 조사 선행 필요.
<!-- SECTION:DESCRIPTION:END -->
