---
id: TASK-123.2
title: 스냅샷 저장 위치/형식 정의
status: Done
assignee: []
created_date: '2026-08-30 12:00'
updated_date: '2026-09-03 01:12'
labels: []
dependencies:
  - TASK-123.1
references:
  - decision-1
parent_task_id: TASK-123
type: task
ordinal: 155000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
123.1에서 기록한 사전 상태를 어디에/어떤 형식으로 남길지 정의한다. 기존 lt_report()(설치 리포트, TASK-107) 패턴을 참고해 $HOME 하위에 저장하되, uninstall 시점에 TASK-124가 이 파일을 읽어 삭제 범위를 결정해야 하므로 lt_report의 사람이 읽기 위한 로그 형식과는 별개로, 파싱하기 쉬운 형식(예: key=value 몇 줄)이 필요할 수 있음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 스냅샷 파일 경로와 형식이 정의되고, TASK-124(uninstall)가 이를 파싱해 읽을 수 있음이 확인됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
스냅샷 저장 위치/형식을 decision-1로 확정: $HOME/.langtoolchain-prior-asdf-state(오버라이드 가능한 LT_PRIOR_STATE_FILE), lt_report()류 사람이 읽는 로그와 별개로 key=value 4줄(asdf_preexisting/asdf_data_dir/asdf_data_dir_preexisting/asdf_plugins_preexisting) 파싱 전용 형식. TASK-123.1에서 쓰기(lt_snapshot_prior_asdf_state)와 읽기(lt_prior_state_get) 헬퍼를 함께 구현하고, spec/lib_spec.sh 라운드트립 테스트(쓰기→읽기, 키 없음/파일 없음 실패 케이스 포함)로 '파싱해 읽을 수 있음'을 확인함. TASK-124.1은 이 lt_prior_state_get() 헬퍼만 호출하면 되도록 설계됨.
<!-- SECTION:FINAL_SUMMARY:END -->
