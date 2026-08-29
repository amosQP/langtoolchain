---
id: TASK-101
title: 07_validate.sh용 pnpm/gradle 바이너리 정보 추가
status: Done
assignee: []
created_date: '2026-08-29 13:41'
updated_date: '2026-08-29 13:52'
labels: []
milestone: m-7
dependencies: []
type: task
ordinal: 116000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
binary_for_plugin()에 pnpm->pnpm, gradle->gradle 매핑 추가. flag_for_binary()에 버전 확인 플래그 추가 — gradle --version은 멀티라인 배너 출력이라 07_validate.sh의 version_core() 비교 로직이 실제로 맞는 라인을 잡아내는지 실기기에서 직접 확인 필요(플레인 --version만으로 안 되면 별도 처리 고려).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
구현 완료. binary_for_plugin()은 pnpm/gradle 둘 다 기존 default case(*) echo "$1")로 이미 정확히 처리됨(plugin명==binary명이라 별도 항목 불필요, 코드 추가 안 함). flag_for_binary()도 default(--version)로 pnpm은 문제없음(실제 확인: 'pnpm --version' -> 'clean single line 10.33.0'). 진짜 문제는 07_validate.sh의 'head -n 1'이었음 - 실제 'gradle --version' 라이브 실행해보니 첫 줄이 버전이 아니라 구분선('---...')이라 WARN 오탐 위험 확인. head -n1을 'grep -m 1 [0-9]'(첫 번째로 숫자를 포함한 줄)로 일반화 - node/java/python/rustc/go 전부 이미 1번째 줄에 버전이 있어서 동작 동일(라이브로 4개 다 재확인), gradle만 실제로 다른 줄을 잡게 됨. validate_spec.sh에 배너형 출력 회귀 테스트 추가.
<!-- SECTION:NOTES:END -->
