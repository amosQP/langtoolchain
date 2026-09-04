---
id: TASK-147
title: 저장소 전체 local 키워드 누락 감사 및 적용
status: Done
assignee: []
created_date: '2026-09-04 08:57'
updated_date: '2026-09-04 14:53'
labels: []
milestone: m-17
dependencies: []
priority: low
type: task
ordinal: 218000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: scripts/lint/check-hardcoded-paths.sh(TASK-125.3, m-14)가 함수
지역 변수(file/line/list/old_ifs/entry 등)를 local 없이 전부 전역으로 선언한다 — 이
저장소의 확립된 관례(TASK-71: local은 POSIX 표준은 아니지만 dash 포함 사실상 모든
POSIX 호환 셸이 지원해서 계속 쓰기로 결정, lib.sh만 해도 24회 사용) 위반이다.

**사용자 확정(2026-09-04)**: local 계속 쓰는 걸로 하고, 이 스크립트뿐 아니라 저장소
전체에서 local이 필요한데 빠진 곳을 찾아 전부 적용한다 — check-hardcoded-paths.sh
하나로 스코프를 한정하지 않는다.

지금 당장 문제를 안 일으키는 이유(is_allowlisted()가 항상 caller의 현재 $file 값으로만
호출됨, POSIX for 루프가 반복 사이에 루프 변수를 다시 읽지 않음)까지 코드리뷰가 확인했지만,
향후 다른 호출 패턴이 추가되면 조용히 깨질 수 있는 잠재 위험이다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
147.1(스캔)+147.2(적용)로 완료. scripts/**/*.sh, install.sh, uninstall.sh 전체
(트리비얼 원라이너 제외 59개 함수)를 대상으로 감사 — 저장소 전체에서 local 누락은
2개 파일 3개 함수 16건뿐이었고(check-hardcoded-paths.sh의 is_allowlisted/check,
uninstall/01_uninstall_runtimes.sh의 uninstall_from_config_file), 이 태스크의
계기였던 check-hardcoded-paths.sh(TASK-125.3) 외 나머지 저장소는 TASK-71 관례를
이미 잘 지키고 있었음을 확인. 전부 순수 스코핑 수정으로 적용, shellcheck 신규
경고 0건(SC3043만 정확히 +2), 전체 shellspec 스위트 bash/dash 양쪽 수정 전후
183 examples 0 failures로 동일 — 동작 변경 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
