---
id: TASK-140.1
title: 라인 길이/들여쓰기/네이밍/주석 헤더/따옴표 규칙 전수 스캔
status: Done
assignee: []
created_date: '2026-09-03 12:07'
updated_date: '2026-09-03 22:27'
labels: []
dependencies: []
parent_task_id: TASK-140
type: task
ordinal: 206000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/**/*.sh, install.sh, uninstall.sh, spec/**/*.sh 전체 대상으로 docs/shell-style-
guide.md의 규칙을 grep/awk 등으로 기계적으로 스캔 가능한 것부터 확인한다: 80자 초과 라인,
탭 문자 사용, 2칸이 아닌 들여쓰기, 함수/변수 네이밍(소문자+언더바 위반), 상수 네이밍
(대문자+언더바 위반 - 특히 최근 추가된 LT_* 상수들), 라이브러리 함수에 Globals/Arguments/
Outputs/Returns 헤더 주석이 없는 경우. 결과를 파일:라인 단위로 목록화한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
shell-style-guide.md 기준 전수 스캔 완료. 대상 39개 .sh 파일. 결과: (1) 라인 길이 >80자 229건(30/39 파일, 대부분 영어 에러메시지/spec 설명문/Korean 주석) — 광범위. (2) 탭 사용 0건. (3) 들여쓰기(2칸 불일치, then/do 이후 스텝 불일치) 0건. (4) 함수 네이밍(소문자+언더바) 위반 0/66건. (5) readonly/export 상수 네이밍(대문자+언더바) 위반 0건이나, ALL_CAPS로 대입되면서 readonly/export 없는 변수 156건(거의 전 파일, SCRIPT_DIR/REPO_ROOT류 준-전역 변수 패턴) — 광범위, 일부는 실제로 값이 바뀌는 변수(SCOPE/SUCCESS/FAILED 등)라 무조건 readonly화하면 버그. (6) 라이브러리 함수 Globals/Arguments/Outputs/Returns 헤더 주석 0/60건 — 대신 저장소 전체가 상세한 산문형 설명 주석 컨벤션을 쓰고 있음, 구조적 불일치. (7) 백틱/eval/local+cmdsub분리/shebang/따옴표(shellcheck SC2086) — 전부 0건의 실질 위반(백틱·eval 언급은 전부 주석/문자열 내용). 상세 목록은 파일:라인 단위로 스크래치패드에 저장(추후 필요시 재현 가능한 스캔 스크립트 포함).
<!-- SECTION:FINAL_SUMMARY:END -->
