---
id: TASK-81
title: TASK-78 수정으로 인해 purge_asdf_core_spec.sh가 실제 brew를 건드릴 뻔함 (near-miss)
status: Done
assignee: []
created_date: '2026-08-28 04:32'
updated_date: '2026-08-28 04:32'
labels:
  - bug
  - test
  - safety
milestone: m-2
dependencies: []
priority: high
type: bug
ordinal: 81000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-78(uninstall 04/05에 ensure_brew_on_path 추가) 적용 직후 전체 shellspec을 돌렸는데, spec/purge_asdf_core_spec.sh의 두 테스트(DRY_RUN=false)가 원래 PATH를 /usr/bin:/bin:/usr/sbin:/sbin으로 제한해서 brew를 못 찾게 막는 방식으로 안전을 확보하고 있었다. 그런데 ensure_brew_on_path()는 command -v로 못 찾으면 uname -m 기반 고정 Homebrew 경로(/opt/homebrew/bin 등)를 무조건 다시 PATH에 넣기 때문에, 이 PATH 제한이 더 이상 안전장치로 작동하지 않게 됐다. 실제로 이 개발 머신의 실제 asdf(brew formula)의 INSTALL_RECEIPT.json 설치 시각이 테스트를 돌린 시점(2026-08-28 13:28:31)과 정확히 일치해서, 테스트가 실제로 brew uninstall asdf를 실행했을 가능성이 매우 높다(다른 모든 formula는 수개월~1년 전 타임스탬프인데 asdf만 방금 것). 사용자 실제 개발 머신에 의도치 않은 변경을 가할 뻔한 near-miss.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 spec/purge_asdf_core_spec.sh가 PATH 제한이 아니라 Mock brew로 brew 호출을 완전히 가로챈다
- [x] #2 수정 후 spec 단독 실행 + 전체 스위트 실행 후에도 실제 asdf의 INSTALL_RECEIPT.json time 필드가 변하지 않음을 확인
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 04:32
---
PATH 제한 대신 Mock brew로 전면 교체 완료 (list asdf/uninstall asdf 둘 다 mock). shellspec spec/purge_asdf_core_spec.sh 단독 실행(3/3 통과) 직후와 전체 스위트(65/65, bash+dash) 실행 직후 둘 다 /opt/homebrew/Cellar/asdf/0.20.0/INSTALL_RECEIPT.json의 time 필드가 1787891311(변경 전과 동일)로 안 바뀐 것 확인 — 실제 brew를 더 이상 안 건드림.
---
<!-- COMMENTS:END -->
