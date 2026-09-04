---
id: TASK-143
title: 라이브러리 함수 60개에 구조화된 헤더(Globals/Arguments/Outputs/Returns) 추가
status: Done
assignee: []
created_date: '2026-09-03 22:28'
updated_date: '2026-09-04 03:32'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lib.sh(주력) 및 재사용 목적 헬퍼 함수를 포함한 6개 파일, 총 60개 함수(TASK-140.1
감사가 센 정확히 그 60개, 파일별 fence 마커 개수/2로 교차검증 완료: lib.sh 37,
scripts/install/00_select.sh 13, scripts/install/01_bootstrap_asdf.sh 4,
scripts/install/07_validate.sh 1, scripts/install/main.sh 1,
scripts/uninstall/01_uninstall_runtimes.sh 1, scripts/uninstall/main.sh 1,
install.sh 1, uninstall.sh 1)에 Google 스타일 Globals/Arguments/Outputs/Returns
구조화 헤더를 추가했다.

decision-11 핵심 규칙 준수: 기존 산문형 "왜" 주석은 전부 보존 — `git diff main...task/
TASK-143`이 9개 파일에 걸쳐 757줄 추가/0줄 삭제만 보였고(각 커밋 diff도 `grep -E '^-[^-]'`
결과 없음으로 개별 확인), 새 헤더는 각 함수의 기존 주석 바로 아래(함수 정의 바로 위)에만
삽입했다. 각 필드는 실제 함수 본문을 근거로 채움 - 지역변수 제외, 콜리(callee) 내부에서만
쓰이는 전역은 제외, 기본 성공/실패를 넘어서는 의미 있는 반환값(예: lt_run_with_timeout의
124, handle_interrupt/die/ensure_disk_space의 "exits, does not return")만 Returns에 명시.

검증: 파일 5개 배치로 나눠 커밋(lib.sh / 00_select.sh / install 스크립트 3개 /
uninstall+install.sh+uninstall.sh 4개), 매 배치마다 shellcheck -s sh 전후 경고 수
동일함을 확인(29/9/5·4·2/4·4·0·0건, 신규 경고 0건) 후 관련 shellspec 파일 단위로
통과 확인. 마지막에 전체 스위트를 sh/bash/dash 세 셸 전부에서 재실행 - 작업 전 baseline과
동일하게 177 examples 0 failures로 회귀 없음 확인.

브랜치: task/TASK-143에 로컬 커밋 4개만 존재(a8cb660, 60fee2e, 0beadbb, 2ac679b) - push
없음.
<!-- SECTION:FINAL_SUMMARY:END -->
