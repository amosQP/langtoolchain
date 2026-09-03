---
id: TASK-118.1
title: 저장소 메타데이터(git tags/GitHub Releases API/언어별 배포 인덱스) 기반 방법 조사
status: To Do
assignee: []
created_date: '2026-08-30 11:40'
labels: []
dependencies: []
parent_task_id: TASK-118
type: spike
ordinal: 142000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
각 언어의 upstream 저장소/배포처에서 최신 안정 버전을 알아내는 방법을 조사한다. 예시 후보(조사하며 확정):
- git ls-remote --tags <repo-url> — 태그 목록을 네트워크 클론 없이 조회 (예: nodejs/node, python/cpython, rust-lang/rust, golang/go)
- GitHub Releases API (api.github.com/repos/<owner>/<repo>/releases/latest) — rate limit(비인증 시 시간당 60회) 고려 필요, 이 저장소가 CI 없이 로컬 실행되는 curl|sh 설치 스크립트라는 점에서 rate limit이 실사용에 문제될지 평가
- 언어별 공식 배포 인덱스: 예 nodejs.org/dist/index.json (LTS 플래그 포함), 각 언어마다 존재 여부/형식이 다름 — 이 저장소가 다루는 7개 언어(nodejs/pnpm/java/gradle/python/rust/golang) 각각에 대해 존재 여부 확인

각 방법에 대해: 언어별 커버리지(7개 전부 지원 가능한지), 인증 필요 여부, 응답 속도, 실패 시 폴백 난이도를 정리.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 nodejs/pnpm/java/gradle/python/rust/golang 7개 언어 각각에 대해 최소 1개 이상의 저장소 메타데이터 기반 방법이 확인됨
- [ ] #2 각 방법의 인증 요구사항·rate limit·응답 속도가 기록됨
<!-- AC:END -->
