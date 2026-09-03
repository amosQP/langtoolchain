---
id: TASK-132
title: prior-state 스냅샷 재수립(refresh) 정책 결정
status: To Do
assignee: []
created_date: '2026-09-03 11:08'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-123.2
  - TASK-124
priority: low
type: spike
ordinal: 188000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: lt_snapshot_prior_asdf_state()(scripts/lib.sh, m-13/decision-6)는
LT_PRIOR_STATE_FILE이 이미 존재하면 조용히 조기 반환하고 다시는 갱신하지 않는다.
install/main.sh에서 최초 1회만 호출되므로, 이 머신에서 그 파일이 처음 만들어지는 순간의 상태가
설치/제거/재설치를 거듭해도 영구 기준선이 된다.

만약 그 최초 스냅샷 시점이 비정상이었다면(예: 이 도구와 무관한 다른 프로세스가 방금
~/.asdf를 만든 직후였다면) 그 오판이 영구 고정되고 이를 바로잡을 방법이 지금 없다.

이 태스크는 코드를 바로 고치는 게 아니라 "이게 의도된 설계(최초 스냅샷 = 영구 기준선)로
그대로 둬도 되는지, 아니면 특정 조건(예: uninstall이 완전히 끝났을 때 스냅샷 파일도 같이
지워서 다음 install이 새 기준선을 잡게 하는 등)에서 재수립을 허용해야 하는지"를 결정하는
스파이크다. 결론은 backlog decision으로 기록하고, 코드 변경이 필요하다고 결론나면 별도
구현 태스크로 분리한다(이 태스크 자체는 결정까지만).
<!-- SECTION:DESCRIPTION:END -->
