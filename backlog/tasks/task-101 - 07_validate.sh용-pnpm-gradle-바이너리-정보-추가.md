---
id: TASK-101
title: 07_validate.sh용 pnpm/gradle 바이너리 정보 추가
status: To Do
assignee: []
created_date: '2026-08-29 13:41'
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
