---
id: TASK-86
title: Homebrew/asdf 외 도구체인과의 상호운용 검토
status: Done
assignee: []
created_date: '2026-08-28 09:42'
updated_date: '2026-08-28 09:58'
labels:
  - docs
milestone: m-2
dependencies: []
priority: low
type: chore
ordinal: 86000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
MacPorts, mise/rtx 같은 대체 패키지/버전 관리자가 이미 설치돼 있는 머신에서 이 도구가 어떻게 동작하는지(충돌 여부, PATH 우선순위 등) 검토된 적 없음. 최소한 알려진 상호작용 여부를 문서화하거나, 필요하면 감지/경고 로직 추가 검토.
<!-- SECTION:DESCRIPTION:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:58
---
MacPorts/mise 상호운용 검토 완료, README(양쪽 언어) '알려진 한계'에 구체화해서 기록. MacPorts는 /opt/local이라 경로 자체는 안 겹치지만 동일 이름 바이너리가 있으면 rc 파일에서 나중에 로드되는 쪽이 이김(설계원칙 #5와 동일 메커니즘) — 실사용 위험은 낮음. mise는 .tool-versions를 직접 읽고 자체 PATH 활성화 훅을 쓰는 asdf의 직접 경쟁자라 더 실질적 위험 — langtoolchain보다 rc에서 나중에 로드되면 asdf shim을 조용히 가릴 수 있음. 둘 다 감지/경고 로직 추가는 스코프 밖으로 판단(TASK-87에서 사용자가 '유지'로 결정한 방향과 동일하게, 검토/문서화까지만).
---
<!-- COMMENTS:END -->
