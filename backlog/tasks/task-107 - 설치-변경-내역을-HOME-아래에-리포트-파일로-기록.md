---
id: TASK-107
title: 설치/변경 내역을 $HOME 아래에 리포트 파일로 기록
status: Done
assignee: []
created_date: '2026-08-30 03:48'
updated_date: '2026-08-30 04:08'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
구현 완료. lib.sh에 LT_REPORT_FILE($HOME/.langtoolchain-report.log, 오버라이드 가능)과 lt_report() 추가 - DRY_RUN 아닐 때만 '타임스탬프 [action] detail' 형식으로 append. install 6개 phase(01,02,03,04,05,06)와 uninstall 5개 phase(01,02,03,04,05) 전부에 실제 변경 지점(brew install/uninstall, asdf plugin add/remove, asdf install/uninstall, asdf set, rc 파일 작성/정리, ~/.asdf 삭제, ~/.tool-versions 삭제)마다 lt_report 호출 추가. $ASDF_DATA_DIR가 아니라 $HOME 바로 밑에 둔 이유: uninstall이 asdf 데이터 디렉토리 전체를 지워도 리포트는 남아야 하니까.

버그 발견 및 즉시 수정: lt_report() 호출을 phase 스크립트에 추가한 직후 전체 테스트 스위트를 돌리다가, 기존 6개 스펙(install_plugins/install_runtimes/install_system_deps/remove_system_deps/remove_plugins/set_globals_spec.sh)이 HOME을 오버라이드하지 않은 채 DRY_RUN=false로 실제 asdf/brew를 Mock해서 도는 구조라, 테스트 돌릴 때마다 실제 사용자의 $HOME/.langtoolchain-report.log를 오염시키고 있었음(실제로 이번 세션 중 그 파일이 96줄까지 쌓인 걸 발견하고 삭제함). 6개 스펙 전부에 LT_REPORT_FILE을 mktemp로 격리하도록 수정, 재검증 결과 실제 홈 디렉토리 파일이 더 이상 생성 안 됨을 확인.

lib_spec.sh에 lt_report() 유닛 테스트 3개 추가(DRY_RUN=false 시 기록, DRY_RUN=true 시 무기록, 여러 줄 누적) - wc -l의 macOS 패딩 이슈를 awk로 우회. 127/127(bash+dash) 통과, shellcheck 에러 0건.
<!-- SECTION:NOTES:END -->
