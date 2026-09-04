---
id: TASK-145
title: 네트워크 호출 타임아웃 예산 일관성 확보
status: To Do
assignee: []
created_date: '2026-09-04 08:56'
labels: []
milestone: m-17
dependencies: []
references:
  - TASK-138
  - TASK-131
priority: medium
type: task
ordinal: 212000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: LT_VERSION_FETCH_TIMEOUT(기본 5초, 원래 작은 JSON API 조회용
값)이 성격이 다른 네트워크 호출에도 그대로 재사용되거나, 아예 타임아웃이 없는 곳이 있다.
lt_run_with_timeout()(TASK-138)이 있는데도 일부 호출엔 안 씌워져 있다.

4개 지점을 각각 다룬다: (1) Homebrew 설치 스크립트 다운로드, (2) python git ls-remote
(cpython 태그 1000개+ enumerate), (3) install.sh/uninstall.sh의 clone_pinned()(self-clone,
타임아웃 자체가 없음), (4) 02_install_plugins.sh의 asdf plugin add/plugin update --all
(내부적으로 git clone, 타임아웃 없음).
<!-- SECTION:DESCRIPTION:END -->
