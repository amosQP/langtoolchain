---
id: m-15
title: "설치 가능 버전 실목록 기반 선택 UI (텍스트 입력 제거)"
---

## Description

사용자 요청(2026-09-03): 언어/동반 도구 버전을 Homebrew의 "update로 먼저 갱신 -> 가능한 버전
전부 확인 -> 실제 설치는 나중에 그 버전을 받는" 모델처럼, 사전에 실제 설치 가능한 버전 목록을
fetch해두고 사용자는 그 중에서만 선택하게 하고 싶다. 현재 있는 자유 텍스트 버전 입력은 제거한다.

이미 확인된 사실:
- 실제 다운로드/컴파일(asdf install)은 이미 scripts/install/05_install_runtimes.sh:39에서
  "선택 이후에만" 실행됨 -- brew upgrade처럼 선택 후 다운로드하는 구조는 이미 존재. 이 부분은
  변경 대상 아님.
- 진짜 갭은 scripts/install/00_select.sh:282-298의 ask_version(): 지금은 "default (default)"
  vs "Enter a specific version"(자유 텍스트, read -r custom) 둘 중 하나뿐. 코드 주석
  (00_select.sh:283-288)에 이미 "실제 설치 가능한 버전에서 고르는 메뉴(asdf list all)는 여기서
  못 쓴다 -- 이 phase 0가 asdf 부트스트랩(phase 1)/플러그인 설치(phase 2)보다 먼저 실행되기
  때문에 아직 조회 수단이 없고, list all은 네트워크 조회라 느릴 수 있다"고 명시돼 있음. 이
  마일스톤은 이 구조적 제약을 푸는 작업이다.
- 이 저장소에서 Homebrew 자체는 버전 선택 대상이 아니라 시스템 패키지 매니저 역할(TASK-63)일
  뿐 -- "Homebrew처럼"은 UX 모델 비유로 해석. 실제 버전 선택 대상은 asdf 관리 언어
  (node/java/python/rust/go)와 동반 도구(pnpm/gradle, 추후 python 동반 도구 TASK-121).

m-12(TASK-118: 언어 버전 기본값 소스 조사·비교, TASK-119: 그 조회 방법 구현)가 이 기능의 직접적
기반이다. TASK-118의 "asdf 명령 기반 vs 저장소 메타데이터 기반" 채택 결정이 이 마일스톤에서
"전체 버전 목록"을 phase 0 시점에 조회할 수 있는지를 좌우한다. m-12는 이 계획 시점에 서브에이전트가
실행 중이므로, 중복 작업을 피하기 위해 이 마일스톤의 착수는 TASK-119 완료 이후로 명시적으로
미룬다(첫 Story에 --dep TASK-119).
