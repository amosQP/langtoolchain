---
id: TASK-90
title: Ctrl-C/시그널 인터럽트 시 명확한 안내 메시지
status: Done
assignee: []
created_date: '2026-08-28 10:02'
updated_date: '2026-08-28 10:10'
labels:
  - feature
  - shell
milestone: m-2
dependencies: []
priority: medium
type: feature
ordinal: 90000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
지금은 EXIT trap만 있고 INT/TERM에 대한 별도 안내가 없어서 Ctrl-C 시 그냥 죽는다. lib.sh에 handle_interrupt() 추가(중단 안내 + exit 130), install/main.sh와 uninstall/main.sh가 lock 획득 직후 trap handle_interrupt INT TERM으로 등록. EXIT trap과는 별개 시그널이라 서로 안 덮어씀.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Ctrl-C 시 '중단됨, 재실행하면 이어집니다' 류의 명확한 메시지가 뜬다
- [x] #2 인터럽트 후에도 EXIT trap(lock 해제 등)이 정상적으로 마저 발동한다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 10:10
---
lib.sh에 handle_interrupt() 추가(중단 안내 메시지 + exit 130), install/main.sh·uninstall/main.sh가 lock 획득 직후 trap handle_interrupt INT TERM 등록(EXIT trap과 별개 슬롯이라 안 덮어씀). 실제 프로세스에 SIGTERM을 보내서 검증: 중단 메시지 출력, exit code 130, EXIT trap(lock 해제)도 정상적으로 마저 발동하는 것 확인. shellspec에서는 실제 exit이라 When run command 서브프로세스로 검증.
---
<!-- COMMENTS:END -->
