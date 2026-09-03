---
id: TASK-128.1
title: lib.sh에 언어별 전체 버전 목록 조회 헬퍼 추가
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
labels: []
dependencies: []
parent_task_id: TASK-128
type: task
ordinal: 174000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
node/java/python/rust/go 각각에 대해 설치 가능한 버전 전체 목록을 반환하는 헬퍼를 lib.sh에
추가한다. TASK-119.1의 기본값 헬퍼와 동일한 case-dispatch 스타일을 따른다. TASK-127에서 asdf
명령 기반으로 결정됐으면 `asdf list all <plugin>` 파싱, 저장소 메타데이터 기반으로 결정됐으면
해당 API/인덱스 파싱으로 구현한다.
<!-- SECTION:DESCRIPTION:END -->
