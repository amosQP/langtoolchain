---
id: TASK-83
title: 로컬 스코프로 설치한 디렉토리를 uninstall이 추적하도록
status: Done
assignee: []
created_date: '2026-08-28 09:42'
updated_date: '2026-08-28 09:52'
labels:
  - feature
  - shell
milestone: m-2
dependencies: []
priority: high
type: feature
ordinal: 83000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
--local로 설치하면 06_set_globals.sh가 <디렉토리>/.tool-versions에 asdf set을 쓰지만, 그 디렉토리 경로가 어디에도 기록되지 않아 01_uninstall_runtimes.sh는 전역/저장소 기본 .tool-versions만 보고 로컬 전용 커스텀 버전은 asdf uninstall 대상에서 놓친다(전체 uninstall.sh 흐름에서는 05_purge_asdf_core.sh가 ~/.asdf 전체를 지워서 최종 결과엔 안 남지만, 01 단독 실행이나 asdf uninstall 로그의 정확성 관점에서 진짜 결함). 구현 방향: 06_set_globals.sh가 로컬 스코프로 asdf set 성공 후 그 디렉토리 절대경로를 $ASDF_DATA_DIR/langtoolchain-local-pins 파일에 추가(중복 없이). 01_uninstall_runtimes.sh가 전역 목록 처리 후 이 파일을 읽어 각 디렉토리의 .tool-versions에 대해서도 동일하게 asdf uninstall을 수행. pins 파일 자체는 $ASDF_DATA_DIR 아래 있어서 05_purge_asdf_core.sh가 지울 때 같이 사라짐. 스코프 경계: 프로젝트 디렉토리의 .tool-versions 파일 자체를 삭제/수정하지는 않음(사용자 프로젝트 파일이라 blast radius가 다름) — 오직 asdf uninstall 대상 식별용.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 --local로 설치한 디렉토리 경로가 $ASDF_DATA_DIR/langtoolchain-local-pins에 기록된다 (DRY_RUN이면 기록 안 함)
- [x] #2 01_uninstall_runtimes.sh 단독 실행 시 로컬 전용 커스텀 버전도 asdf uninstall 된다
- [x] #3 shellspec 회귀 테스트 추가
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-28 09:52
---
06_set_globals.sh가 local scope로 asdf set 성공 후 $ASDF_DATA_DIR/langtoolchain-local-pins에 대상 디렉토리를 중복 없이 기록(DRY_RUN이면 기록 안 함). 01_uninstall_runtimes.sh가 전역 config 처리 후 이 파일을 읽어 각 디렉토리의 .tool-versions에 대해서도 동일하게 asdf uninstall 수행(공용 로직은 uninstall_from_config_file()로 추출, fd 4로 fd 3과 충돌 방지). spec/set_globals_spec.sh(4예제)+spec/uninstall_runtimes_spec.sh(4예제) 신규, shellspec 78/78(bash+dash) 통과, shellcheck -s sh/dash -n 전부 클린. README(양쪽 언어) 필드 문서화 + '알려진 한계'에서 제거.
---
<!-- COMMENTS:END -->
