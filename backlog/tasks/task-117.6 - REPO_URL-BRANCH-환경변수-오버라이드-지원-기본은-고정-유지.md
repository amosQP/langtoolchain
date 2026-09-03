---
id: TASK-117.6
title: REPO_URL/BRANCH 환경변수 오버라이드 지원 (기본은 고정 유지)
status: To Do
assignee: []
created_date: '2026-08-30 12:00'
labels: []
dependencies:
  - TASK-117.1
parent_task_id: TASK-117
type: task
ordinal: 150000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
외부 리뷰(2026-08-30) 지적: install.sh:20-21의 REPO_URL/BRANCH가 하드코딩돼 있어 포크나 별도 브랜치에서 curl|sh 형태로 테스트해볼 수 없음 (uninstall.sh도 동일 값을 중복 관리 — install.sh:19 주석 "REPO_URL/BRANCH here, change uninstall.sh too" 참고).

TASK-117.1(self-clone을 고정 커밋/태그로 전환)과 방향이 반대처럼 보이지만 절충 가능: 기본 실행 경로는 고정 참조를 유지하되, 명시적 환경변수(예: LANGTOOLCHAIN_REPO_URL, LANGTOOLCHAIN_BRANCH)로만 오버라이드를 허용하고, 오버라이드가 감지되면 "신뢰할 수 없는 소스일 수 있다"는 경고를 출력한다. install.sh와 uninstall.sh 양쪽 다 반영해야 함(주석에 이미 중복 관리 필요성이 명시돼 있음).
<!-- SECTION:DESCRIPTION:END -->
