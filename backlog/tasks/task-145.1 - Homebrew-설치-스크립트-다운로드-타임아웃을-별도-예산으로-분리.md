---
id: TASK-145.1
title: Homebrew 설치 스크립트 다운로드 타임아웃을 별도 예산으로 분리
status: Done
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 13:55'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 213000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/01_bootstrap_asdf.sh의 fetch_verified_homebrew_installer()가 스크립트
전체 다운로드를 5초(LT_VERSION_FETCH_TIMEOUT, JSON API 조회용 값)로 제한하고 있다.
느리지만 정상인 연결(모바일 테더링 등)에서 6~8초 걸리는 다운로드가 매 재시도(retry 3 5)
마다 동일하게 실패한다. 더 큰 값(또는 별도 LT_DOWNLOAD_TIMEOUT류 상수)으로 분리한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
fetch_verified_homebrew_installer()의 curl --max-time을 LT_VERSION_FETCH_TIMEOUT(5s, JSON API용 공유값)에서 01_bootstrap_asdf.sh 자체 선언인 LT_DOWNLOAD_TIMEOUT(기본 30s, 오버라이드 가능)으로 분리. spec/bootstrap_asdf_spec.sh의 정적 검증 테스트 변수명 갱신. shellcheck 신규 경고 0건, shellspec(bash+dash) 177/177 통과.
<!-- SECTION:FINAL_SUMMARY:END -->
