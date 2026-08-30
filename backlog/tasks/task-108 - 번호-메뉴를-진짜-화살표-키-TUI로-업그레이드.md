---
id: TASK-108
title: 번호 메뉴를 진짜 화살표 키 TUI로 업그레이드
status: Done
assignee: []
created_date: '2026-08-30 04:25'
updated_date: '2026-08-30 04:25'
labels: []
milestone: m-10
dependencies: []
type: task
ordinal: 123000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-106의 번호 메뉴(1/2 입력)를 backlog.md CLI의 @clack/prompts 스타일 화살표 키 TUI로 업그레이드해달라는 사용자 요청. 처음엔 'read -n1이 POSIX/dash에 없어서 불가능'이라고 잘못 판단했으나, 사용자가 'POSIX 쓰면서도 화살표로 선택 가능하지 않냐'고 정정 — stty -icanon -echo(raw 모드 전환) + dd bs=1 count=1(외부 명령, 셸 내장 read -n1 아님)로 한 글자씩 읽으면 dash에서도 완전히 동작함을 실제 pty로 검증 후 정정, 정책 변경(bash 전용 전환) 없이 순수 POSIX로 구현.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
구현 완료. lt_arrow_menu()(00_select.sh) 신규 추가 — stty -icanon -echo + dd bs=1 count=1로 raw 모드 한 글자 읽기, ESC+[+A/B 3바이트 시퀀스로 방향키 감지, 매 키 입력마다 커서를 위로 올려 전체 블록 재출력(clack 스타일), Enter 확정 시 한 줄 요약(✔ 질문 답변)으로 접힘. 숫자 키 즉시 선택도 유지. ask_yes_no()/ask_version()/스코프 질문/최종 확인 전부 이걸로 통일 — 외부 호출 시그니처는 그대로라 다른 파일 변경 불필요.

raw 모드 안전장치: stty 원복을 EXIT trap에 연결(_LT_RAW_STTY 전역 + lt_restore_raw_stty)해서 메뉴 도중 Ctrl-C가 와도 터미널이 raw 상태로 안 남게 함. 이 안전장치 자체에 버그가 있었음 — raw 모드가 아닐 때 lt_restore_raw_stty가 '[ -n "" ]' 실패로 함수 전체가 실패 상태를 반환했고, 그게 EXIT trap 안에서 스크립트의 실제 exit code(0)를 덮어써서 --all 등 비대화형 경로 전부가 exit 1로 깨지는 회귀를 유발 — select_spec.sh 5개 중 4개가 즉시 잡아냄. if문으로 구조 바꿔서 항상 exit 0 하도록 수정.

dash 실 pty로 화살표 위/아래(wrap 포함), Enter, 숫자 키 단축 전부 검증. 통합된 00_select.sh 전체 흐름(nodejs 거절→java 수락→버전 메뉴)도 dash pty로 재확인. README(한/영) transcript를 화면에 남는 접힌 요약 형태로 갱신. 127/127(bash+dash) 통과, shellcheck 에러 0건.
<!-- SECTION:NOTES:END -->
