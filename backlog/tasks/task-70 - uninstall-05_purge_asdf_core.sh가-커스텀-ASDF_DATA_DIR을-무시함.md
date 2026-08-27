---
id: TASK-70
title: uninstall/05_purge_asdf_core.sh가 커스텀 ASDF_DATA_DIR을 무시함
status: Done
assignee: []
created_date: '2026-08-27 14:23'
updated_date: '2026-08-27 20:21'
labels:
  - code-quality
milestone: m-5
dependencies: []
priority: low
type: bug
ordinal: 70000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
05_purge_asdf_core.sh:16이 LT_ASDF_DATA_DIR_DEFAULT를 무조건 사용해서, 커스텀 $ASDF_DATA_DIR을 쓰는 사용자가 uninstall을 돌려도 실제 데이터 디렉토리가 아니라 기본 $HOME/.asdf만 검사/삭제한다. 리팩토링(TASK-62) 이전부터 있던 동작이라 이번에 새로 생긴 회귀는 아니지만, 코드리뷰에서 지적된 실제 한계라 기록해둔다. ensure_asdf_on_path()가 이미 쓰는 "${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}" 패턴을 여기도 적용하면 해결됨.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 05_purge_asdf_core.sh가 라이브 $ASDF_DATA_DIR 값이 있으면 그걸 우선 사용하고, 없을 때만 LT_ASDF_DATA_DIR_DEFAULT로 폴백한다
<!-- AC:END -->
