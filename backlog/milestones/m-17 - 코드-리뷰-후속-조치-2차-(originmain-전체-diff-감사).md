---
id: m-17
title: "코드 리뷰 후속 조치 2차 (origin/main 전체 diff 감사)"
---

## Description

2026-09-04, m-11~m-16 전체를 origin/main 대비 diff로 놓고 /code-review high를 다시 돌려서
나온 9건. m-16(TASK-130~143)이 이미 처리한 것과 별개로 새로 발견된 것들이다.

가장 중요한 발견(TASK-144)은 이 세션에서 실제 UAT(이 컴퓨터에 실사용 중이던 asdf 상태를
대상으로 install.sh/uninstall.sh를 진짜로 실행)로 직접 재현/확인됐다: m-13이 만든
prior-state 스냅샷이 asdf_preexisting 값을 기록은 하지만 05_purge_asdf_core.sh의
`brew uninstall asdf` 호출이 그 값을 읽어서 게이팅하지 않는다 — 그래서 실제로 asdf
바이너리가(설치 전부터 있었는데도) 지워졌다.

나머지는 네트워크 호출 타임아웃 예산 일관성(4곳), java 버전 조회 브랜치의 exit code
계약 위반, lint 스크립트 자체의 컨벤션 미준수(local 미사용 + Intel 경로 미검사), 버전
캐시의 시계 역행 취약점, 동적 기본값이 asdf가 아직 못 따라잡은 버전을 권할 수 있는 문제다.
