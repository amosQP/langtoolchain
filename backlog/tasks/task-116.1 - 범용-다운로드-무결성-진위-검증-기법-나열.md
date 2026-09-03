---
id: TASK-116.1
title: 범용 다운로드 무결성/진위 검증 기법 나열
status: To Do
assignee: []
created_date: '2026-08-30 11:33'
labels: []
dependencies: []
parent_task_id: TASK-116
type: spike
ordinal: 133000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
셸 기반 설치 스크립트/패키지 매니저 맥락에서 쓰이는 다운로드 파일 검증 기법을 모두 나열하고 각각의 전제조건·한계를 정리한다.

포함해야 할 후보 목록 (초안, 조사하며 보강):
- 체크섬 비교: SHA-256/SHA-512 해시값을 신뢰 채널(HTTPS로 별도 게시된 .sha256 파일 등)에서 받아 다운로드물과 대조
- GPG/PGP 서명 검증: detached signature(.asc/.sig) + 게시자 공개키로 서명 확인 (예: 커널/Node.js 릴리스 방식)
- minisign/signify: GPG보다 단순한 대안 서명 방식
- Sigstore/cosign 키리스(keyless) 서명: OIDC 신원 기반 서명, 최근 npm/컨테이너 이미지 생태계에서 채택 확산
- TLS 인증서 검증/고정(certificate pinning): 전송 구간 신뢰만 보장, 다운로드물 자체의 진위는 별도로 보장 안 함(전제조건 vs 한계 구분 필요)
- 코드 서명(Authenticode/codesign/notarization): 플랫폼 네이티브 실행파일 서명 체계, macOS/Windows 배포물에 해당
- 패키지 매니저 자체 신뢰 체인: Homebrew bottle 서명, apt/rpm 저장소 GPG 서명 등 — "위임"이 곧 검증 전략이 될 수 있음
- git commit SHA/태그 고정 + signed tag 검증(git tag -v): 브랜치 플로팅 대신 불변 참조 사용
- 재현 가능한 빌드(reproducible build) + 독립 해시 대조
- SRI(Subresource Integrity) 개념의 셸 스크립트 유사 적용 (해시를 스크립트에 하드코딩)

각 기법에 대해: 무엇을 보장하는지, 무엇을 보장하지 않는지, 이 저장소 규모의 POSIX sh 프로젝트에 현실적으로 적용 가능한지 평가.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 다운로드 무결성/진위 검증 기법이 최소 6개 이상 나열되고 각각의 보장 범위·한계가 기술됨
- [ ] #2 각 기법이 curl/git/패키지매니저 등 이 저장소가 실제 쓰는 도구에서 어떻게 구현 가능한지 구체적 명시
<!-- AC:END -->
