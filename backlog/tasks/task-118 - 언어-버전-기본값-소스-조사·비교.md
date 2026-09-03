---
id: TASK-118
title: 언어 버전 기본값 소스 조사·비교
status: Done
assignee: []
created_date: '2026-08-30 11:40'
updated_date: '2026-09-03 01:12'
labels: []
milestone: m-12
dependencies: []
type: spike
ordinal: 140000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
현재 .tool-versions(저장소 루트)의 정적 값이 유일한 기본값 소스. 이 스토리는 그것을 대체/보강할 동적 소스 후보를 조사하고 비교한다.

핵심 제약(반드시 반영): scripts/install/00_select.sh:284-288 주석 — asdf list all <plugin>을 phase 0에서 안 쓰는 이유(플러그인 미설치 가능성, 네트워크 지연). 조사는 이 제약 안에서 동작할 방법(다른 시점에 fetch, 캐싱 등)을 찾는 것을 목표로 한다.

기존 코드 스타일 참고: scripts/lib.sh:542-572의 binary_for_plugin()/lt_companion_for_plugin() — 언어별 case-dispatch 패턴(연관 배열 대신, bash 3.2/POSIX sh 호환 유지). 새 버전 조회 헬퍼도 이 스타일을 따를 가능성이 높음.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3개 하위 태스크(118.1/118.2/118.3) 모두 완료. 언어별 저장소 공식 메타데이터/API
기반 조회를 채택(decision-1), asdf 자체 명령은 phase 0 제약(플러그인 미설치)을
우회하지 못해 기각. 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 전부에
대한 구체적 소스/필드/파싱 방법을 실측 확인, TASK-119 구현의 입력으로 확정.
<!-- SECTION:FINAL_SUMMARY:END -->
