---
id: TASK-125.1
title: 하드코딩 대상 패턴 목록화 및 회귀 사례 근거 정리
status: To Do
assignee: []
created_date: '2026-09-03 01:14'
labels: []
dependencies: []
parent_task_id: TASK-125
type: docs
ordinal: 162000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-57(39108c5), TASK-61(7422cfd), TASK-65(c73f1ae), TASK-70(cf438f9), TASK-78(77d913f) 커밋 diff를 근거로 감지해야 할 하드코딩 패턴을 목록화한다.

확인된 패턴:
- ASDF_DATA_DIR을 쓰지 않고 '.asdf' 리터럴 문자열로 경로/PATH를 매칭 (TASK-57, TASK-65)
- Apple Silicon 전용 Homebrew prefix(/opt/homebrew)를 arch 분기 없이 하드코딩 — lt_homebrew_prefix() 미사용 (TASK-61)
- $LT_ASDF_DATA_DIR_DEFAULT를 항상 사용하고 런타임 ASDF_DATA_DIR 오버라이드를 무시 (TASK-70)
- brew/asdf를 PATH에 올리는 ensure_*_on_path() 헬퍼 호출 누락 — PATH에 이미 있다고 암묵 가정 (TASK-78, 성격은 다르지만 '환경 하드코딩'의 인접 사례로 포함)

각 패턴별로: 어떤 grep/정규식으로 잡을 수 있는지, 어떤 lib.sh 헬퍼(lt_homebrew_prefix, ensure_asdf_on_path, ${ASDF_DATA_DIR:-...} 패턴)를 쓰는 게 정답인지 정리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 TASK-57/61/65/70/78 diff 각각의 하드코딩 지점과 올바른 대안이 표로 정리됨
- [ ] #2 감지 대상 패턴(문자열/정규식) 목록이 문서화됨
<!-- AC:END -->
