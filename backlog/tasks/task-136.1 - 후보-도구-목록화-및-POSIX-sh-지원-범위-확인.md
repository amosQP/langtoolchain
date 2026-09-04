---
id: TASK-136.1
title: 후보 도구 목록화 및 POSIX sh 지원 범위 확인
status: In Progress
assignee: []
created_date: '2026-09-03 11:31'
updated_date: '2026-09-04 19:58'
labels: []
dependencies: []
parent_task_id: TASK-136
type: task
ordinal: 193000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SonarQube(Community/Developer 에디션별 shell 분석 지원 여부), CodeQL(지원 언어 목록에
shell 포함 여부), Semgrep(커스텀 룰로 shell 패턴 매칭 가능한지), 기타(shellharden 등)를
조사해 후보 목록을 만든다. 각 도구가 실제로 POSIX sh(.sh, bash 특수문법 없음)에 대해
shellcheck를 넘어서는 유의미한 탐지를 제공하는지, 아니면 사실상 shellcheck 재포장 수준인지
확인한다. 무료/개인 프로젝트(이 저장소는 public이지만 "개인 툴링") 사용 가능 여부(가격
정책)도 함께 조사.
<!-- SECTION:DESCRIPTION:END -->
