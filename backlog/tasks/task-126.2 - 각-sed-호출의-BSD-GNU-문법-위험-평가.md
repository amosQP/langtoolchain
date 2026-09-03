---
id: TASK-126.2
title: 각 sed 호출의 BSD/GNU 문법 위험 평가
status: In Progress
assignee: []
created_date: '2026-09-03 01:15'
updated_date: '2026-09-03 06:06'
labels: []
dependencies:
  - TASK-126.1
modified_files:
  - scripts/lint/sed-portability-audit.md
parent_task_id: TASK-126
type: task
ordinal: 168000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-126.1에서 목록화한 각 sed 호출 지점을 BSD/GNU 문법 차이 관점에서 평가한다. 특히 -i(in-place) 사용 시 BSD sed(빈 문자열 인자 필수)와 GNU sed(인자 없이 동작, 또는 다른 방식) 차이, 확장 정규식(-E vs -r) 차이, \1 백레퍼런스 차이 등을 확인.

중요: 반드시 이 macOS 개발 머신의 실제 /bin/sed로 각 호출을 검증한다 — Linux GNU sed 결과나 문헌 지식만으로 판단하지 않는다. 저장소가 macOS 전용이므로 실질 위험은 '이 저장소가 GNU sed 환경(예: Homebrew gsed, Linux CI)에서 실행될 가능성이 있는가'와 '현재 macOS 기본 BSD sed에서 실제로 깨지는가' 둘 다 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 각 sed 호출 지점의 BSD/GNU 위험 여부가 실제 /bin/sed 실행 결과로 검증됨
- [x] #2 위험 지점과 안전한 지점이 구분되어 목록에 표시됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
이 macOS 개발 머신의 실제 /usr/bin/sed(BSD sed, macOS 26.6.2)로 두 호출 모두 직접 실행해 검증. (1) scripts/lib.sh:601: -i 없는 읽기전용 BRE, temurin-25.0.2/lts/1.2 샘플로 의도대로 동작 확인 - 위험 없음. (2) scripts/uninstall/03_clean_env_vars.sh:61 sed -E -i '.bak' "$@" "$rc": 실제 rc 샘플 파일에 동일 호출을 실행해 대상 줄만 정확히 삭제되고 .bak 백업이 원본 그대로 생성됨을 확인 - 위험 없음. 추가로 sed -i -e '...' file(접미사 인자 생략) 형태를 같은 sed로 실제 재현해, BSD sed가 -e 문자열 자체를 백업 접미사로 삼켜버려 file-e라는 엉뚱한 백업이 생기는 실제 함정을 확인했고, 03_clean_env_vars.sh가 이미 .bak를 명시적으로 줘서 이 함정을 피하고 있음을 재확인. 결과를 scripts/lint/sed-portability-audit.md에 문서화.
<!-- SECTION:FINAL_SUMMARY:END -->
