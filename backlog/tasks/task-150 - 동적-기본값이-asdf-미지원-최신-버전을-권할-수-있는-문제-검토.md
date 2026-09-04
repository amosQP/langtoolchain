---
id: TASK-150
title: 동적 기본값이 asdf 미지원 최신 버전을 권할 수 있는 문제 검토
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-128
priority: low
type: spike
ordinal: 223000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: 00_select.sh의 인터랙티브 프롬프트 기본값이 이제
lt_resolve_default_version()(m-12) 경유로 언어 공식 소스(예: cpython 태그)에서 오는데,
asdf 플러그인(예: python-build)이 아직 그 최신 버전을 못 따라잡았을 수 있다. 사용자가
그 기본값을 그대로 수락하면 phase 5(05_install_runtimes.sh)의 `asdf install`이 "version
not installable" 로 실패하는 새로운 실패 유형이 생긴다(예전엔 기본값이 정적 .tool-versions
고정값이라 이 문제가 없었음).

바로 고치지 말고 먼저 검토: (a) 설치 전에 asdf가 그 버전을 실제로 설치 가능한지 확인하는
사전 체크를 추가할지(비용/복잡도 증가), (b) 실패 시 에러 메시지를 명확히 해서 사용자가
이해하고 재시도하게 할지(TASK-88의 retry로는 근본 해결 안 됨 - 버전 자체가 문제이므로),
(c) 그냥 알려진 한계로 문서화만 하고 넘어갈지. 결론은 backlog decision으로 기록.
<!-- SECTION:DESCRIPTION:END -->
