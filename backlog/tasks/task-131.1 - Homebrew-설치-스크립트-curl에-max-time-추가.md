---
id: TASK-131.1
title: Homebrew 설치 스크립트 curl에 --max-time 추가
status: Done
assignee: []
created_date: '2026-09-03 11:08'
updated_date: '2026-09-03 11:34'
labels: []
dependencies: []
parent_task_id: TASK-131
type: task
ordinal: 186000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/01_bootstrap_asdf.sh의 fetch_verified_homebrew_installer()가 쓰는
curl -fsSL -o "$dest" "$HOMEBREW_INSTALL_URL"에 --max-time "$LT_VERSION_FETCH_TIMEOUT"을
추가해서 같은 파일/diff의 다른 curl 호출들과 통일한다. 타임아웃 시 fetch_verified_homebrew_
installer가 실패를 반환하고 retry 3 5가 정상적으로 재시도하는지 mock으로 확인.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
fetch_verified_homebrew_installer()의 curl -fsSL -o "$dest" "$HOMEBREW_INSTALL_URL"에 --max-time "$LT_VERSION_FETCH_TIMEOUT"을 추가 (scripts/install/01_bootstrap_asdf.sh:55) — 같은 파일의 다른 curl 호출들과 통일. dash -n / shellcheck -s sh 통과. spec/bootstrap_asdf_spec.sh에 정적 검증 테스트 1개 추가: curl 호출 라인에 --max-time과 LT_VERSION_FETCH_TIMEOUT이 포함되는지 grep. 동적(Mock 기반) 타임아웃/재시도 행위 테스트는 시도했으나 불가능함을 확인: 01_bootstrap_asdf.sh가 \$0/dirname으로 자기 위치(SCRIPT_DIR)를 찾아 lib.sh를 sourcing하는데, 이는 스크립트를 서브프로세스로 실행할 때만($0=스크립트 경로) 성립하고 '.'으로 직접 source하면 깨짐(LT_VERSION_FETCH_TIMEOUT unbound 확인). 서브프로세스 경로로 테스트하려면 brew가 실제로 PATH에 없어야 하는데, 이 파일 헤더 코멘트가 이미 문서화했듯 Mock은 real absence를 시뮬레이션 못하고 PATH 제한은 Mock의 prepend를 깨뜨림 — 이 spec 파일의 기존 제약(다른 브랜치)과 동일 계열의 한계라 e2e-verify.yml에 위임. shellspec spec/bootstrap_asdf_spec.sh: 3 examples 0 failures. 전체 스위트: 166 examples 0 failures.
<!-- SECTION:FINAL_SUMMARY:END -->
