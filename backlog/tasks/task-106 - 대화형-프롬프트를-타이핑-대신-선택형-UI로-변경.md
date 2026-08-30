---
id: TASK-106
title: 대화형 프롬프트를 타이핑 대신 선택형 UI로 변경
status: Done
assignee: []
created_date: '2026-08-30 03:48'
updated_date: '2026-08-30 03:57'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
구현 완료. 00_select.sh에 ask_yes_no()/ask_version() 헬퍼 추가 - Y/n 자유 타이핑 대신 '1) Yes(default) / 2) No' 번호 메뉴, 버전 자유 입력 대신 '1) <기본값>(default) / 2) 직접 입력' 번호 메뉴로 통일. 언어 설치 여부, 동반 도구 설치 여부, 전역/로컬 스코프, 최종 확인까지 전부 이 패턴 적용. 'asdf list all <plugin>'로 실제 버전 목록을 보여주는 방식은 검토했으나 기각 - 00_select.sh가 파이프라인의 phase 0(가장 먼저 실행)이라 이 시점엔 asdf/plugin이 아직 없을 수 있고, list all 자체도 네트워크 fetch라 느릴 수 있어 안 씀. 대신 기본값 선택/커스텀 입력 이분 구조로, 흔한 경로(기본값 그대로)는 번호 하나로 끝나고 진짜 필요할 때만 타이핑하도록 함. y/n/no 같은 기존 키워드도 계속 인식해서 하위호환 유지. expect로 실제 pty 통해 nodejs 수락→버전 기본값 수락→pnpm 거절→java 거절까지 라이브로 전 구간 검증함(이 샌드박스에서 이번엔 끝까지 안 막혔음). README(한/영) transcript 예시 전부 갱신. 124/124(bash+dash) 통과, shellcheck 에러 0건.
<!-- SECTION:NOTES:END -->
