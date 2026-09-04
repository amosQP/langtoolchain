---
id: TASK-145.1
title: Homebrew 설치 스크립트 다운로드 타임아웃을 별도 예산으로 분리
status: In Progress
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 13:53'
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
