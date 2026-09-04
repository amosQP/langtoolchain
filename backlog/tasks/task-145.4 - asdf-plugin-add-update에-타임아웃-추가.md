---
id: TASK-145.4
title: asdf plugin add/update에 타임아웃 추가
status: Done
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 14:28'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 216000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/02_install_plugins.sh의 retry 3 5 run asdf plugin add "$plugin"과
asdf plugin update --all이 내부적으로 git clone/fetch를 실행하는데 타임아웃이 없다.
lt_run_with_timeout()으로 감싸서 멈춘 연결에서도 retry가 실제로 재시도할 기회를 갖게 한다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
02_install_plugins.sh의 asdf plugin add/plugin update --all을 lt_run_with_timeout()(TASK-138.1)으로 감싸 하드 타임아웃 확보. 이 스크립트는 이미 lib.sh를 source하므로 함수를 그대로 재사용(다른 진입점처럼 인라인 복제가 필요 없음). LT_PLUGIN_TIMEOUT(기본 30s, 오버라이드 가능) 신규 도입, retry 3 5 run과 조합. spec/install_plugins_spec.sh의 setup()에 LT_PLUGIN_TIMEOUT=1 추가 - 기본 30s를 그대로 두면 성공 케이스에서도 watchdog이 백그라운드에 남긴 leftover sleep이 살아있는 동안 테스트 스위트 종료가 지연됨을 실측으로 확인(31s -> 2.5s로 단축, lib_spec.sh TASK-138.2 테스트가 LT_VERSION_FETCH_TIMEOUT=1을 쓰는 것과 같은 이유/패턴). 조사 중 실수로 mock 디렉터리가 실제로 생성되지 않은 상태에서 PATH를 수동 조작해 real asdf가 우연히 실행되어 'asdf plugin update --all'이 이 머신에 실제로 한 번 실행됨(비파괴적: 플러그인 git 체크아웃 갱신만 발생, 언어/Homebrew 변경 없음, asdf plugin list로 확인) - 이후 전부 shellspec Mock 경유로만 재검증. shellcheck 신규 경고 0건, shellspec(bash+dash) 179/179 통과.
<!-- SECTION:FINAL_SUMMARY:END -->
