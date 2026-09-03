---
id: TASK-140.2
title: 위반 사례 심각도 분류 및 처리
status: Done
assignee: []
created_date: '2026-09-03 12:07'
updated_date: '2026-09-03 22:31'
labels: []
dependencies:
  - TASK-140.1
parent_task_id: TASK-140
type: task
ordinal: 207000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
140.1 스캔 결과를 심각도로 분류한다: (a) 사소하고 국소적인 것(예: 라인 길이 몇 자 초과,
주석 헤더 누락)은 이 태스크에서 바로 고친다 — 동작 변경 없는 순수 스타일 수정이므로
shellspec 전후 동일 통과만 확인하면 됨. (b) 광범위하거나 구조적 변경이 필요한 것은 고치지
않고 별도 태스크로 분리해서 backlog에 기록만 한다(스코프를 감사+국소 수정으로 한정).
"발견된 위반 없음"도 유효한 결과다 — 없는 문제를 만들어 고치지 않는다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-140.1의 스캔 결과를 심각도로 분류했다. 결론: 이번 감사에서 발견된 항목 중 '사소하고 국소적'인 것은 하나도 없었다 — 카테고리별로 (a) 위반 0건이거나 (b) 저장소 전반에 걸친 광범위/구조적 패턴이었다. 따라서 이 태스크에서 직접 수정한 코드는 없다(위반 없음도 유효한 결과라는 지침에 따름).

0건 확인(수정 불필요): 탭 문자 사용, 2칸 들여쓰기 불일치(odd-indent 및 then/do 이후 스텝 검사 모두 클린), 함수 네이밍(소문자+언더바, 66/66 준수), readonly/export 선언부 자체의 대문자+언더바 네이밍, 백틱 사용(전부 주석 내 인용), eval 실사용(전부 주석/문자열), local+명령치환 분리 위반, shebang 불일치, shellcheck 기준 따옴표 누락(SC2086 1건은 의도적 word-splitting이라 위반 아님).

광범위/구조적이라 직접 고치지 않고 별도 태스크로 분리(TASK-140 참조로 연결):
- TASK-141: 라인 길이 80자 초과 229건(30/39 파일) — 대규모 리랩 필요, 문자열 오분할 위험
- TASK-142: ALL_CAPS 변수 156건이 readonly/export 없이 선언 — 상당수가 실제로 재대입되는 가변 상태라 기계적 readonly화가 오히려 버그를 유발함, 변수별 정책 판단 선행 필요
- TASK-143: 라이브러리 함수 60/60개가 Globals/Arguments/Outputs/Returns 헤더 대신 기존 산문형 설명 주석 컨벤션을 씀 — 실제 코드를 60곳 고칠지, docs/shell-style-guide.md 쪽을 기존 관행에 맞게 수정할지 정책 결정이 선행되어야 함

코드 변경이 없으므로 shellspec 전후 비교는 해당 없음. 다만 상태 확인 차 전체 스위트를 bash/dash 양쪽으로 돌려 177 examples, 0 failures를 확인했다(TASK-140.1 작업 전 main에 85개 커밋 fast-forward 병합을 반영한 뒤의 베이스라인 확인).
<!-- SECTION:FINAL_SUMMARY:END -->
