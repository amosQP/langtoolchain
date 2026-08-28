---
id: TASK-82
title: README 문서정합성 감사 + 영문 README 추가
status: Done
assignee: []
created_date: '2026-08-28 09:09'
updated_date: '2026-08-28 09:09'
labels:
  - docs
milestone: m-5
dependencies: []
priority: medium
type: chore
ordinal: 82000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
TASK-76이 'README가 POSIX sh 호환을 정확히 반영한다'고 체크했지만, 실제로는 설계 원칙 #2 예시 코드가 여전히 제거된 bash 프로세스 치환(`3< <(each_tool ...)`)을 보여주고 있어 원칙 #4의 POSIX 선언과 같은 문서 안에서 서로 모순됐다. 그 외에도: 대화형 스코프 프롬프트 예시 문구 2곳이 오늘 수정한 실제 프롬프트(기본값 표시 추가)와 어긋남, lib.sh 함수 표에 version_core/lt_homebrew_prefix/lt_env_var_defs 누락, main.sh 표에 --local 플래그 누락, '남은 To-Do' 체크리스트가 이미 e2e CI로 검증된 2개 항목(Homebrew 부트스트랩, Intel Mac)을 계속 미완료로 표시, POSIX sh 배지가 bash 로고를 쓰고 있어 바로 옆 'bash 특수문법 없음' 문구와 모순, 기여하기 섹션에 shellspec 테스트 스위트 언급이 전혀 없었음. 전부 수정. 추가로 영문 README(readme.en.md)를 새로 작성하고 두 파일 상단에 언어 전환 링크를 추가.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 readme.md의 프롬프트 예시/함수 표/To-Do 체크리스트가 현재 코드와 일치한다
- [x] #2 readme.en.md가 readme.md와 같은 구조로 존재하고 TOC 앵커가 정확하다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:09
---
readme.md 7군데 수정(스코프 프롬프트 예시 2곳, 원칙 #2 코드 예시, lib.sh 함수 표 3개 추가, main.sh 표 --local 추가, To-Do 체크리스트 2개 체크, 배지 로고 제거, 기여하기 섹션에 shellcheck/dash/shellspec 절차 및 e2e-verify.yml 언급 추가). readme.en.md 신규 작성(490줄, 전체 번역+수정 반영), 양쪽 파일 상단에 언어 전환 링크 추가. TOC 앵커는 원본 한글 파일의 이모지별 앵커 패턴(⚙️는 %EF%B8%8F 유지, 🗂️는 미유지)을 그대로 따라 계산.
---
<!-- COMMENTS:END -->
