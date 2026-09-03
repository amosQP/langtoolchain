---
id: TASK-123
title: 이 도구 설치 전부터 존재하던 asdf 상태 감지
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:13'
labels: []
milestone: m-13
dependencies: []
type: task
ordinal: 152000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
uninstall이 삭제 범위를 축소하려면 install 시점에 "이 도구가 오기 전 이미 무엇이 있었는지"를 알아야 한다. 현재 install 흐름(scripts/install/main.sh 01~07 phase)엔 이런 사전 상태 기록이 전혀 없음.

기록해야 할 것: asdf 자체가 이미 설치돼 있었는지(brew list asdf), $TARGET_ASDF_DATA_DIR(lt_asdf_data_dir() 반환값, 기본 ~/.asdf)가 이미 존재했는지, 그 안에 이미 어떤 플러그인이 있었는지(asdf plugin list).
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
두 서브태스크(TASK-123.1 스냅샷 기록 구현, TASK-123.2 저장 위치/형식 결정=decision-1)로 완료. asdf 사전 설치 여부/데이터 디렉토리 존재 여부/기존 플러그인 목록이 install/main.sh의 phase 루프(01_bootstrap_asdf.sh 포함) 시작 전에 $HOME/.langtoolchain-prior-asdf-state에 기록됨.
<!-- SECTION:FINAL_SUMMARY:END -->
