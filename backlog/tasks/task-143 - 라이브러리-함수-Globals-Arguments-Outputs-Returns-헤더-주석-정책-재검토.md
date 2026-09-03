---
id: TASK-143
title: 라이브러리 함수 Globals/Arguments/Outputs/Returns 헤더 주석 정책 재검토
status: To Do
assignee: []
created_date: '2026-09-03 22:28'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-140
documentation:
  - docs/shell-style-guide.md
priority: low
type: chore
ordinal: 210000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-140.1 스캔 결과: docs/shell-style-guide.md는 '라이브러리 함수는 전부(길이 무관) Globals/Arguments/Outputs/Returns를 명시하는 헤더 주석'을 요구하지만, 실제로 scripts/lib.sh 등에 정의된 함수 60개 전부가 이 리터럴 포맷을 쓰지 않음(0/60). 대신 저장소 전체가 처음부터(TASK-71 이전부터) 함수 위에 왜(why)를 설명하는 상세한 산문형 주석(배경, 과거 버그, 설계 이유 등)을 다는 컨벤션을 일관되게 써왔고, 이 산문형 주석은 품질 자체는 높음 — 다만 Google 스타일 가이드가 요구하는 4개 필드 구조는 아님.

TASK-140.2에서 '광범위하고 구조적'으로 분류해 직접 수정하지 않음 — 60개 함수 전부에 Globals/Arguments/Outputs/Returns를 새로 써 붙이는 건 국소 스타일 수정이 아니라 대규모 문서화 작업이고, 각 함수의 실제 전역 변수 의존성/인자/출력/반환값을 정확히 파악해서 써야 하므로 잘못 쓰면 오히려 오해를 유발하는 위험한 작업임.

권장 접근: 이 작업에 들어가기 전에 먼저 정책 재검토가 필요 — (a) 기존 산문형 주석 컨벤션이 사실상 이미 Globals/Arguments/Outputs/Returns가 답하려는 질문(이 함수가 뭘 읽고 쓰는지, 인자가 뭔지, 뭘 출력/반환하는지)을 충분히 설명하고 있다면 docs/shell-style-guide.md 쪽을 '구조적 헤더 필수'에서 '산문형 설명 주석 허용'으로 수정해 실제 컨벤션에 맞추는 게 나을 수 있음, (b) 아니면 실제로 60개 함수에 구조적 헤더를 소급 추가하는 대규모 작업으로 갈지 결정. 둘 중 뭘 택하든 이 판단은 사람(유저)의 승인이 필요한 정책 결정이라 이 감사 태스크(TASK-140) 스코프 밖으로 분리함.
<!-- SECTION:DESCRIPTION:END -->
