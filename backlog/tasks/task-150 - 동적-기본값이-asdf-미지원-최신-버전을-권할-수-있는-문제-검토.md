---
id: TASK-150
title: 동적 기본값이 asdf 미지원 최신 버전을 권할 수 있는 문제 검토
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 13:55'
labels: []
milestone: m-17
dependencies: []
references:
  - decision-12
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
결정: (b) 05_install_runtimes.sh 실패 시 에러 메시지 명확화 + (c) README 알려진 한계 문서화 채택. (a) 사전 asdf list-all 체크는 채택하지 않음 — TASK-128/129(m-15)가 선택 UI를 실 설치가능목록 기반으로 교체하는 작업을 이미 계획 중이라 더 근본적으로 이 문제를 해소하며, 지금 phase 5에 별도 사전 체크를 추가하면 그때 중복/폐기됨. 근거는 decision-12에 기록, TASK-150에 참조 연결(decision-12, TASK-128). 코드 변경 자체는 이 스파이크 범위 밖 — 후속 필요: (1) scripts/install/05_install_runtimes.sh die() 문구에 '버전이 asdf 플러그인 미지원일 수 있음' 안내 추가, (2) README 알려진 한계 섹션에 한 항목 추가. 둘 다 별도 태스크로 백로깅 필요(이번 태스크에서 미생성).
<!-- SECTION:FINAL_SUMMARY:END -->
