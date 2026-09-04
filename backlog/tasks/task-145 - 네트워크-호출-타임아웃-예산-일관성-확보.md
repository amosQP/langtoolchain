---
id: TASK-145
title: 네트워크 호출 타임아웃 예산 일관성 확보
status: Done
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 14:29'
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

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
4개 자식 태스크(145.1~145.4) 모두 완료 - LT_VERSION_FETCH_TIMEOUT(5s, 원래 소형 JSON API용)이 성격이 다른 4개 네트워크 호출에 부적절하게 재사용되거나 아예 타임아웃이 없던 문제를 각각 해소:
(1) 01_bootstrap_asdf.sh의 Homebrew 설치 스크립트 다운로드 - 전용 LT_DOWNLOAD_TIMEOUT(30s) 신설.
(2) lib.sh python 브랜치의 git ls-remote(cpython 태그 1000+) - 전용 LT_PYTHON_TAGS_TIMEOUT(20s) 신설(refs 필터는 순환 의존 문제로 기각).
(3) install.sh/uninstall.sh 각자의 clone_pinned() - 두 파일 다 lib.sh를 source 못 하는 최초 진입점이라 lt_run_with_timeout()의 워치독 로직을 clone_fetch_with_timeout()으로 인라인 복제, CLONE_FETCH_TIMEOUT(30s) 신설.
(4) 02_install_plugins.sh의 asdf plugin add/update --all - 이미 lib.sh를 source하므로 lt_run_with_timeout() 그대로 재사용, LT_PLUGIN_TIMEOUT(30s) 신설.
공통 패턴: 모두 override 가능한 ${VAR:-default} 상수로, 테스트가 짧게 줄여 쓸 수 있게 함(145.4에서 이걸 안 했을 때 leftover watchdog sleep이 테스트 스위트를 31s -> 정상 대비 크게 느리게 만드는 것을 실측으로 확인, 이후 LT_PLUGIN_TIMEOUT=1 오버라이드로 해결).
전 구간 shellcheck 신규 경고 0건, shellspec(bash+dash) 179/179 통과(기존 175 기준 +4 테스트: 145.3에서 fake-git 블랙홀 회귀 테스트 2건 추가, 145.1/145.2/145.4는 기존 테스트를 새 변수명/설정에 맞춰 갱신만 함).
<!-- SECTION:FINAL_SUMMARY:END -->
