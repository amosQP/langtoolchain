---
id: TASK-131.2
title: python 버전 조회를 하드 타임아웃 방식으로 전환 검토
status: Done
assignee: []
created_date: '2026-09-03 11:08'
updated_date: '2026-09-03 11:37'
labels: []
dependencies: []
references:
  - decision-10
parent_task_id: TASK-131
type: task
ordinal: 187000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lib.sh의 lt_upstream_latest_version() python 브랜치(git ls-remote 기반)를 http.lowSpeedLimit/
lowSpeedTime 대신 하드 wall-clock 타임아웃으로 바꾸는 방법을 조사한다: (a) timeout 커맨드로
git ls-remote 전체를 감싸기(POSIX sh에는 timeout(1)이 기본 없을 수 있어 가용성 확인 필요),
(b) git config http.postBuffer/connectTimeout류 다른 옵션 조합, (c) python 버전 조회 자체를
git ls-remote 대신 다른 소스(예: PyPI/GitHub API)로 바꿔서 curl --max-time을 재사용하는 근본적
전환. 셋 중 채택안을 backlog decision으로 기록.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3안 실측 조사 완료, decision-10에 기록. (a) timeout(1)/gtimeout(1): 이 개발 머신엔 Homebrew coreutils로 존재하지만 이 저장소가 타깃하는 '완전히 새 Mac'(Homebrew도 없는 상태, phase 0)엔 stock macOS에 없음 - 기각. (b) git http.* config: man git-config 전수 확인 결과 connect/wall-clock 타임아웃 옵션 자체가 없음(lowSpeedLimit/lowSpeedTime이 유일, 그게 바로 지금 문제) - 기각. (c) GitHub tags API로 소스 전환: 실측(curl api.github.com/repos/python/cpython/tags) 결과 프리릴리스가 최종 릴리스보다 먼저 나와 페이지네이션 필터링이 필요, 네트워크 호출 지점이 늘어나고 decision-4가 이미 닫은 python 소스 결정을 재작업해야 함 - TASK-131 스코프 밖, 기각. 채택 가능한 안이 없어 4번째 안(POSIX sh 백그라운드 job + kill 워치독, lt_run_with_timeout() 초안)을 decision-10에 권고안으로 기록했으나 TASK-131.2 자체 스코프(조사+결정 기록)를 넘는 프로덕션 코드 변경이라 구현하지 않음 - 별도 후속 태스크 필요. lib.sh는 이번 태스크에서 수정하지 않음(코드 변경 없음, 문서만 추가).
<!-- SECTION:FINAL_SUMMARY:END -->
