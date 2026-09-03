---
id: TASK-143
title: 라이브러리 함수 60개에 구조화된 헤더(Globals/Arguments/Outputs/Returns) 추가
status: To Do
assignee: []
created_date: '2026-09-03 22:28'
updated_date: '2026-09-03 22:38'
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
TASK-140.1 스캔 결과: docs/shell-style-guide.md는 '라이브러리 함수는 전부(길이 무관)
Globals/Arguments/Outputs/Returns를 명시하는 헤더 주석'을 요구하지만, 실제로 scripts/
lib.sh 등에 정의된 함수 60개 전부가 이 리터럴 포맷을 쓰지 않음(0/60). 대신 저장소 전체가
처음부터(TASK-71 이전부터) 함수 위에 왜(why)를 설명하는 상세한 산문형 주석(배경, 과거
버그, 설계 이유 등)을 다는 컨벤션을 일관되게 써왔음.

**사용자 직접 결정(decision-11, 2026-09-04)**: 양자택일이 아니라 둘 다 한다 — 기존
산문형 "왜" 주석은 그대로 두고, 그 위에 구조화된 헤더를 추가로 붙인다. 산문형 주석은
LLM(Claude Code)이 이 코드를 다시 다룰 때 "왜 이렇게 짰는지" 의도를 전달하는 핵심
통로이므로 절대 지우지 않는다.

작업 범위: scripts/lib.sh(주력) 등에 정의된 함수 60개 각각에 대해, 기존 산문형 주석
바로 아래(또는 함수 정의 바로 위) Globals/Arguments/Outputs/Returns 형식의 헤더를
추가한다. 각 필드는 그 함수가 실제로 읽는 전역변수, 받는 인자, 내놓는 출력(stdout/stderr),
반환값(기본 종료코드 이상의 의미가 있을 때만)을 정확히 파악해서 쓴다 — 틀리게 쓰면
오해를 유발하므로 실제 코드를 근거로 작성한다.
<!-- SECTION:DESCRIPTION:END -->
