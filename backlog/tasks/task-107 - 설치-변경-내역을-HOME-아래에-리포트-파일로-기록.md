---
id: TASK-107
title: 설치/변경 내역을 $HOME 아래에 리포트 파일로 기록
status: To Do
assignee: []
created_date: '2026-08-30 03:48'
labels: []
milestone: m-10
dependencies: []
type: task
ordinal: 122000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
무엇이 어디에 설치되거나 어떤 파일이 변경됐는지 $HOME 아래 리포트 파일로 남기는 기능. 기존 LT_LOCAL_PINS_FILE_NAME(TASK-83) 패턴처럼 $ASDF_DATA_DIR 또는 $HOME 밑에 로그 파일 위치/포맷 설계, 각 phase 스크립트가 이벤트(brew install, asdf plugin add, asdf install, rc 파일 수정 등)를 append하는 공용 lib.sh 함수 필요. uninstall도 대칭적으로 무엇을 지웠는지 기록하면 좋음.
<!-- SECTION:DESCRIPTION:END -->
