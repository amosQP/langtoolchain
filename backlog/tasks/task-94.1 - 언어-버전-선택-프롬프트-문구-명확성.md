---
id: TASK-94.1
title: 언어/버전 선택 프롬프트 문구 명확성
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:46'
labels: []
dependencies: []
parent_task_id: TASK-94
type: task
ordinal: 99000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
00_select.sh의 '[Y/n]', 버전 기본값 표시, 잘못된 입력(Enter만 치는 경우 등) 처리 문구를 실제로 읽고 사용자가 헷갈릴 지점이 있는지 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
리뷰 완료 - 특별한 이슈 없음. 'Install nodejs (node)? [Y/n] > ' 형태로 대문자 Y가 기본값(Enter=yes)임을 표준 컨벤션대로 표시. 버전 프롬프트도 '[default: lts]' 형태로 명확. java의 기본 버전값이 'temurin-25.0.2+10.0.LTS'처럼 긴 vendor 문자열이라 다소 낯설 수 있으나 실제 asdf-java 플러그인의 실제 버전 문자열 그대로라 문제라 보긴 어려움.
<!-- SECTION:NOTES:END -->
