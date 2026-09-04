---
id: TASK-151
title: 'TASK-150 결정 반영: 에러 메시지 명확화 + README 안내 추가'
status: Done
assignee: []
created_date: '2026-09-04 14:33'
updated_date: '2026-09-04 15:11'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-150
  - decision-12
priority: low
type: task
ordinal: 224000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-150/decision-12에서 결정된 두 가지 코드 변경(결정만 하고 구현은 안 함):

1. scripts/install/05_install_runtimes.sh의 die() 호출부 문구에 "일부 실패는 asdf
   플러그인이 아직 해당 버전을 지원하지 않아서일 수 있다(asdf list all <plugin>으로
   확인 후 .tool-versions를 수동 수정해 재시도)" 취지 추가. shellspec에 에러 문자열
   검증 케이스 추가.
2. README.md(및 readme.en.md)의 '알려진 한계' 섹션에 "동적 기본값이 asdf 미지원 최신
   버전을 제안할 수 있고, m-15(TASK-128/129) 완료 시 구조적으로 해소될 예정"이라는
   안내 한 항목 추가.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/install/05_install_runtimes.sh의 FAILED die() 메시지에 "asdf 플러그인이 아직
그 버전을 지원하지 않을 수 있다 - asdf list all <plugin>으로 확인 후 .tool-versions
수동 수정해 재시도" 안내 추가 (decision-12 반영). spec/install_runtimes_spec.sh 기존
실패 케이스에 이 문구 검증 어서션 추가. readme.md/readme.en.md '알려진 한계' 섹션에
동적 기본값이 asdf 미지원 버전을 제안할 수 있다는 항목과 m-15 완료 시 구조적 해소
예정임을 명시. shellspec 전체 183 examples 0 failures(sh/bash/dash), shellcheck
신규 경고 없음(SC1091 베이스라인만).
<!-- SECTION:FINAL_SUMMARY:END -->
