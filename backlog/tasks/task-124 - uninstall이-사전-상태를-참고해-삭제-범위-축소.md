---
id: TASK-124
title: uninstall이 사전 상태를 참고해 삭제 범위 축소
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:18'
labels: []
milestone: m-13
dependencies:
  - TASK-123
type: task
ordinal: 153000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-123(사전 상태 감지)의 결과를 실제로 scripts/uninstall/05_purge_asdf_core.sh에 반영한다. 현재 이 스크립트는 lt_asdf_data_dir() 결과 디렉토리가 존재하기만 하면 무조건 rm -rf한다(주석: "이 도구가 설치한 모든 런타임을 지운다").

변경 방향: 설치 시점 스냅샷에 "asdf/데이터 디렉토리가 이미 있었음"이 기록돼 있으면 전체 rm -rf를 스킵하거나, 최소한 명시적 확인(예: "이 디렉토리는 langtoolchain 설치 전부터 있었던 것으로 보입니다. 그래도 전체 삭제할까요?")을 받도록 바꾼다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
두 서브태스크로 완료. TASK-124.1: 05_purge_asdf_core.sh가 lt_prior_state_get(TASK-123)으로 얻은 asdf_data_dir_preexisting 값을 확인해, 명시적으로 'false'일 때만 rm -rf하고 'true'/스냅샷 없음일 땐 스킵+경고(안전 기본값)로 전환(shellspec 7예제). TASK-124.2: README(한/영)에 이 동작 변경과 기존 사용자(스냅샷 없음 → 기본 스킵) 안내 추가. brew uninstall asdf/~/.tool-versions 삭제는 스코프 밖이라 기존 그대로 유지.
<!-- SECTION:FINAL_SUMMARY:END -->
