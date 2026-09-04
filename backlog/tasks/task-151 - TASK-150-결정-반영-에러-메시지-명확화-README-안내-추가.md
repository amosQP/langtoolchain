---
id: TASK-151
title: 'TASK-150 결정 반영: 에러 메시지 명확화 + README 안내 추가'
status: In Progress
assignee: []
created_date: '2026-09-04 14:33'
updated_date: '2026-09-04 15:05'
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
