---
id: TASK-131.1
title: Homebrew 설치 스크립트 curl에 --max-time 추가
status: To Do
assignee: []
created_date: '2026-09-03 11:08'
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
