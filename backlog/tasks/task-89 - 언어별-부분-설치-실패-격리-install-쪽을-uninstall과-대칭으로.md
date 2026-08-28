---
id: TASK-89
title: 언어별 부분 설치 실패 격리 (install 쪽을 uninstall과 대칭으로)
status: Done
assignee: []
created_date: '2026-08-28 10:02'
updated_date: '2026-08-28 10:10'
labels:
  - bug
  - shell
milestone: m-2
dependencies: []
priority: high
type: bug
ordinal: 89000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
uninstall 쪽(01_uninstall_runtimes.sh, 02_remove_plugins.sh)은 이미 run ... || true로 개별 항목 실패가 전체를 안 죽이는데, install 쪽(02_install_plugins.sh, 05_install_runtimes.sh)은 이 패턴이 없어서 언어 하나 실패하면 set -e로 전체가 즉시 죽고 나머지 언어는 시도조차 안 된다. 개별 실패를 누적하고 루프는 계속 진행, 루프 끝난 뒤 실패가 있으면 die()로 전체 파이프라인 중단(6단계가 실패한 언어에 asdf set을 실행하지 않도록).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 5개 언어 중 하나가 실패해도 나머지는 전부 시도된다
- [x] #2 하나라도 실패하면 루프가 끝난 뒤 명확한 메시지와 함께 전체가 실패로 끝난다(6단계로 안 넘어감)
- [x] #3 shellspec 회귀 테스트 추가
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 10:10
---
02_install_plugins.sh와 05_install_runtimes.sh를 uninstall 쪽과 대칭으로 수정 — 개별 실패를 FAILED 변수에 누적, 루프는 계속 진행, 끝난 뒤 실패가 있으면 die()로 전체 실패. shellspec으로 실제 검증: 언어 여러 개 중 하나만 계속 실패하게 Mock해도 나머지는 전부 시도되고(출력에 포함), 최종적으로는 명확한 메시지와 함께 전체 실패. 88/88(bash+dash) 통과.
---
<!-- COMMENTS:END -->
