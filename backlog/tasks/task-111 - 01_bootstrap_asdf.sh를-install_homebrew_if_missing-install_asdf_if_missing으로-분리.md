---
id: TASK-111
title: 01_bootstrap_asdf.sh를 install_homebrew_if_missing/install_asdf_if_missing으로 분리
status: Done
assignee: []
created_date: '2026-08-30 04:51'
updated_date: '2026-08-30 04:51'
labels: []
milestone: m-8
dependencies: []
type: task
ordinal: 126000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Homebrew/asdf 각각의 '있으면 스킵, 없으면 설치' 블록을 이름 붙은 함수로 추출 - 스크립트 본문이 두 함수 호출로 요약됨.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
적용 완료. install_homebrew_if_missing()/install_asdf_if_missing() 추출, 스크립트 본문이 두 함수 호출로 요약됨.
<!-- SECTION:NOTES:END -->
