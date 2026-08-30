---
id: TASK-115
title: README '알려진 한계' 섹션 확충 (한/영 양쪽)
status: Done
assignee: []
created_date: '2026-08-30 05:15'
updated_date: '2026-08-30 05:22'
labels: []
dependencies: []
ordinal: 130000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
CI 트리거 관련 서술이 TASK-85 이후로 stale함(수동 전용 -> push/PR 자동 + 수동 유지로 바뀜). 이번 세션에서 드러난 미해결 기술적 갭(REPO_URL/BRANCH 하드코딩으로 로컬에서 원격 clone 재시도 경로 자체 테스트 불가, 로컬 shellspec은 실제 Homebrew/asdf를 안 건드리므로 진짜 설치 동작 검증은 GitHub Actions 실기기에만 의존, 화살표 키 TUI가 표준 터미널 기준으로만 검증됨 등)을 readme.md/readme.en.md의 '알려진 한계 / 앞으로 할 일' 섹션에 반영.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
readme.md/readme.en.md '알려진 한계' 섹션을 범위상 한계/테스트 검증의 한계/앞으로 살펴볼 것 3개 하위섹션으로 확충(CI 자동트리거화(TASK-85) 반영해 stale 서술 수정, REPO_URL/BRANCH 하드코딩·로컬 shellspec이 실제 brew/asdf 안 건드림·화살표 TUI 검증 범위 등 이번 세션에서 드러난 기술적 갭 반영). 이후 유저 추가 요청으로 리드미 전체를 대폭 축약(각 631/639줄 -> 201/204줄, 총 1270->405줄) - 빠른참조/파일시스템명세/코드구조/설계원칙/어떻게동작하는가 등 중복·과도상세 섹션을 제거하고 왜만들었는지/사용법/실행화면/macOS전용 안내/한계 5가지 핵심만 남김. 코드 변경 없음(문서 전용).
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
README 알려진 한계 섹션 확충 + 전체 대폭 축약(문서 전용, 코드 변경 없음)
<!-- SECTION:FINAL_SUMMARY:END -->
