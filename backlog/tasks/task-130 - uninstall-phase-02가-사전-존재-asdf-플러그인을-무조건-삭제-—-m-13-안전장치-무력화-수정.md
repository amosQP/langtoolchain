---
id: TASK-130
title: uninstall phase 02가 사전 존재 asdf 플러그인을 무조건 삭제 — m-13 안전장치 무력화 수정
status: Done
assignee: []
created_date: '2026-09-03 11:07'
updated_date: '2026-09-03 11:22'
labels: []
milestone: m-16
dependencies: []
priority: high
type: bug
ordinal: 181000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high(2026-09-03, m-11~m-14 병합 diff 대상)가 발견: m-13이 만든 "설치 전부터
있던 asdf 상태는 지우지 않는다"는 안전장치(lt_snapshot_prior_asdf_state/lt_prior_state_get,
scripts/uninstall/05_purge_asdf_core.sh에 통합됨)가 실제로는 무력화되어 있다.

원인: uninstall은 phase 02(scripts/uninstall/02_remove_plugins.sh, m-13 당시 손대지
않음)가 phase 05보다 먼저 실행되는데, 02는 설치된 모든 asdf 플러그인에 대해 조건 없이
`asdf plugin remove`를 실행한다. phase 05가 "데이터 디렉토리는 사전 존재했으니 안 지운다"고
올바르게 판단할 때쯤엔 이미 사용자가 langtoolchain 설치 전부터 갖고 있던 플러그인/버전들이
phase 02에서 다 사라진 뒤다. readme.md/readme.en.md의 "langtoolchain이 설치하지 않은 asdf
플러그인은 건드리지 않는다"는 서술과 실제 동작이 어긋난다.

이 Story는 phase 02에도 prior-state 체크를 적용해서 실제로 그 약속이 지켜지게 만드는 것이다.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
3개 자식 태스크(130.1 설계, 130.2 구현+spec, 130.3 README 정합성) 전부 완료. /code-review high가 지적한 실제 안전 버그(phase 02가 사전 존재 asdf 플러그인을 무조건 삭제해 m-13 안전장치를 무력화)를 수정 - scripts/uninstall/02_remove_plugins.sh가 이제 05_purge_asdf_core.sh와 동일한 lt_prior_state_get() 헬퍼로 플러그인 단위 사전존재 여부를 확인해 skip한다. 전체 shellspec 168 examples 0 failures로 회귀 없음 확인.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
TASK-130.1/130.2/130.3 전부 Done. scripts/uninstall/02_remove_plugins.sh가 asdf_plugins_preexisting 스냅샷을 확인해 사전 존재 플러그인은 skip(lt_report skipped)하고 신규 설치분만 제거하도록 수정, spec/remove_plugins_spec.sh에 혼재/스냅샷없음/키없음 3개 시나리오 추가(brew/asdf 항상 Mock). readme.md/readme.en.md의 uninstall 서술을 실제 동작과 정합시킴. shellcheck 클린, scripts/lint/check-hardcoded-paths.sh 통과, 전체 shellspec 168 examples 0 failures.
<!-- SECTION:FINAL_SUMMARY:END -->
