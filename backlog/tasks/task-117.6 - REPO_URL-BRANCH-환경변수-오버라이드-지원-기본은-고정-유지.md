---
id: TASK-117.6
title: REPO_URL/BRANCH 환경변수 오버라이드 지원 (기본은 고정 유지)
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:30'
labels: []
dependencies:
  - TASK-117.1
documentation:
  - spec/repo_override_spec.sh
parent_task_id: TASK-117
type: task
ordinal: 150000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
외부 리뷰(2026-08-30) 지적: install.sh:20-21의 REPO_URL/BRANCH가 하드코딩돼 있어 포크나 별도 브랜치에서 curl|sh 형태로 테스트해볼 수 없음 (uninstall.sh도 동일 값을 중복 관리 — install.sh:19 주석 "REPO_URL/BRANCH here, change uninstall.sh too" 참고).

TASK-117.1(self-clone을 고정 커밋/태그로 전환)과 방향이 반대처럼 보이지만 절충 가능: 기본 실행 경로는 고정 참조를 유지하되, 명시적 환경변수(예: LANGTOOLCHAIN_REPO_URL, LANGTOOLCHAIN_BRANCH)로만 오버라이드를 허용하고, 오버라이드가 감지되면 "신뢰할 수 없는 소스일 수 있다"는 경고를 출력한다. install.sh와 uninstall.sh 양쪽 다 반영해야 함(주석에 이미 중복 관리 필요성이 명시돼 있음).
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
install.sh/uninstall.sh 양쪽에 LANGTOOLCHAIN_REPO_URL/LANGTOOLCHAIN_BRANCH 환경변수 오버라이드 추가 — 기본값(REPO_URL, 고정 커밋 SHA)은 그대로 유지하고 ${VAR:-default} 패턴으로만 오버라이드. 둘 중 하나라도 설정되면 네트워크 clone 직전에 WARNING을 stderr로 출력(로컬 clone 단축 경로에서는 절대 안 뜸). 이 오버라이드 덕분에 그동안 로컬에서 테스트 불가능하던 curl|sh 원격 clone 경로 자체를 처음으로 회귀 테스트 가능하게 만듦 — spec/repo_override_spec.sh 신설: 로컬 bare 저장소(file://) 2커밋(구/신)을 만들어 (1) 신규 커밋 pin 시 stub main.sh 마커 출력+WARNING 확인 (2) 구 커밋 pin 시 그 커밋엔 main.sh가 없어 실패하는 것으로 clone_pinned()가 '최신'이 아니라 '정확히 그 ref'를 받아온다는 것 자체를 검증. sh -s -- <args> < install.sh로 curl|sh의 $0=sh 상황 재현. shellcheck/dash -n/shellspec 135/135(bash+dash) 통과. README.md/readme.en.md의 관련 stale 서술(REPO_URL/BRANCH 하드코딩으로 테스트 불가) 갱신.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
install.sh/uninstall.sh에 LANGTOOLCHAIN_REPO_URL/LANGTOOLCHAIN_BRANCH 환경변수 오버라이드 추가 — 기본은 TASK-117.1의 고정 커밋 SHA 유지, 오버라이드 시 stderr에 '검증되지 않은 소스' 경고. 이를 계기로 그동안 README가 '로컬 재현 불가'로 명시했던 curl|sh 원격 clone 경로를 spec/repo_override_spec.sh로 처음 회귀 테스트화(로컬 file:// bare repo로 exact-ref pin 동작까지 검증). shellcheck/dash -n/shellspec 135/135(bash+dash) 통과. README.md/readme.en.md 갱신.
<!-- SECTION:FINAL_SUMMARY:END -->
