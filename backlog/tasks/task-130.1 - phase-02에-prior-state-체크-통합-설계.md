---
id: TASK-130.1
title: phase 02에 prior-state 체크 통합 설계
status: To Do
assignee: []
created_date: '2026-09-03 11:07'
labels: []
dependencies: []
parent_task_id: TASK-130
type: task
ordinal: 182000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
lt_prior_state_get()이 반환하는 asdf_plugins_preexisting은 공백구분 플러그인 목록이라
이미 플러그인 단위 정보를 갖고 있다. 02_remove_plugins.sh가 플러그인별로 이 목록에 있는지
확인해서 사전 존재 플러그인은 skip하고, langtoolchain이 새로 추가한 플러그인만 제거하도록
설계한다. 05_purge_asdf_core.sh가 이미 쓰는 것과 동일한 lt_prior_state_get() 헬퍼를 그대로
재사용할지, 플러그인 목록 매칭을 위한 별도 헬퍼가 필요한지 결정한다.
<!-- SECTION:DESCRIPTION:END -->
