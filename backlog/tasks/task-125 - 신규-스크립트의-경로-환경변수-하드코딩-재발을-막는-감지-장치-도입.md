---
id: TASK-125
title: 신규 스크립트의 경로/환경변수 하드코딩 재발을 막는 감지 장치 도입
status: To Do
assignee: []
created_date: '2026-09-03 01:14'
labels: []
milestone: m-14
dependencies: []
type: task
ordinal: 161000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이 저장소에서 같은 클래스의 버그가 반복 재발했다: 경로/환경변수를 하드코딩해 커스텀 설정(ASDF_DATA_DIR, Apple Silicon vs Intel Homebrew prefix 등)을 무시하는 패턴이 TASK-57, TASK-61, TASK-65, TASK-70, TASK-78에서 각각 독립적으로 발견·수정됐다. 수정은 매번 사후 대응이었고, 재발을 막는 자동 감지 장치가 없었다.

이 Story는 신규 스크립트에서 같은 클래스의 버그가 반복되지 않도록 감지 장치(린트/테스트/CI 게이트)를 도입한다. 자식 태스크 순서: 125.1(패턴 목록화·근거 정리) -> 125.2(감지 방식 결정) -> 125.3(구현+CI 연결) -> 125.4(기존 코드 전수 스캔, 위반 발견 시 그 자리에서 고치지 않고 별도 버그 태스크로 분리).

모든 자식 태스크가 끝나면 Done 처리.
<!-- SECTION:DESCRIPTION:END -->
