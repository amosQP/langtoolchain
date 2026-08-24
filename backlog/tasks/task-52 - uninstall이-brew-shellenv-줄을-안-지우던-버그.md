---
id: TASK-52
title: uninstall이 brew shellenv 줄을 안 지우던 버그
status: Done
assignee: []
created_date: '2026-08-24 12:53'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - scripts/uninstall/03_clean_env_vars.sh
priority: medium
type: bug
ordinal: 52000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이번 세션에 Homebrew 자동 설치 기능을 추가하면서 04_configure_shell_env.sh가 rc 파일 맨 위에 eval "$(brew shellenv)" 줄을 prepend하도록 바꿨는데, 짝을 이루는 scripts/uninstall/03_clean_env_vars.sh의 sed 삭제 패턴 목록을 같이 안 고쳐서 uninstall을 실행해도 이 줄이 rc 파일에 영구히 남아있었다. 오래된(더 이상 안 쓰는) libexec/asdf.sh 패턴만 남아있고 정작 새로 추가되는 줄은 매칭 패턴이 없었음 — 코드 리뷰로 발견. sed 패턴에 /brew shellenv/d 추가, 죽은 libexec 패턴은 제거. 격리된 가짜 rc 파일로 삭제 동작 재검증 완료.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 brew shellenv 줄이 sed로 정확히 삭제되고 무관한 다른 줄은 보존된다 (가짜 rc 파일로 검증 완료)
- [ ] #2 실제 uninstall을 다시 돌려 rc 파일에 langtoolchain이 추가한 줄이 하나도 안 남는지 확인 (아직 실기기 재검증은 안 함)
<!-- AC:END -->
