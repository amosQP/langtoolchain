---
id: TASK-56
title: uninstall이 macOS BSD sed에서 Java home 훅 줄을 못 지우던 버그
status: Done
assignee: []
created_date: '2026-08-24 13:03'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - scripts/uninstall/03_clean_env_vars.sh
priority: medium
type: bug
ordinal: 56000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
03_clean_env_vars.sh의 sed 패턴 /set-java-home\.\(zsh\|bash\)/d에서 \| 대체 문법은 GNU sed 확장이고, macOS 기본 /usr/bin/sed(BSD sed)의 POSIX BRE 모드에서는 지원되지 않아 아무것도 매칭하지 못했다. 즉 uninstall을 실행해도 set-java-home.zsh/bash 훅 줄이 rc 파일에 세션 내내 계속 남아있었음 — 실기기가 아니라 이번에 실제로 rc 파일을 만들어 돌려보다가 발견. sed -E 플래그 추가 + 패턴을 ERE 문법으로 교체해서 수정, 실제 내용으로 재검증.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 set-java-home.zsh/bash 줄이 실제 rc 파일 내용에서 정확히 제거된다 (재검증 완료)
<!-- AC:END -->
