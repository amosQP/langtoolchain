---
id: TASK-110
title: 00_select.sh 언어 처리 로직을 lt_offer_language()로 분리
status: Done
assignee: []
created_date: '2026-08-30 04:51'
updated_date: '2026-08-30 04:51'
labels: []
milestone: m-8
dependencies: []
type: task
ordinal: 125000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
메인 while 루프 안에 인라인으로 있던 '언어 하나 질문+기록+동반도구 루프'(27줄)를 lt_offer_language(plugin, default_version)로 추출 - 루프 자체는 '스킵 체크 -> lt_offer_language 호출'로 요약됨.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
적용 완료. lt_offer_language(plugin, default_version) 추출, 메인 while 루프는 스킵 체크 후 이 함수 호출 한 줄로 요약됨.
<!-- SECTION:NOTES:END -->
