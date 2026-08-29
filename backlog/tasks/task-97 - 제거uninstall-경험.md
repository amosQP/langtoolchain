---
id: TASK-97
title: 제거(uninstall) 경험
status: Done
assignee: []
created_date: '2026-08-29 12:24'
updated_date: '2026-08-29 12:47'
labels: []
milestone: m-6
dependencies: []
type: task
ordinal: 97000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
uninstall 실행 시 무엇이 지워질지 사전에 알 수 있는지, 06_validate_teardown.sh의 FAIL/안내 문구가 실제로 문제 해결에 도움되는지, 부분 설치 상태에서 제거해도 깔끔하게 끝나는지(멱등성 UX) 점검.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
하위 3개(97.1-3) 전부 리뷰 완료. 97.1(uninstall tty 없을 때 raw stderr 노출)은 이미 수정됨(commit 25db8ec). 97.3에서 확인한 '이 도구가 설치 안 한 plugin까지 제거'는 의도된 동작으로 확인, 버그 아님.
<!-- SECTION:NOTES:END -->
