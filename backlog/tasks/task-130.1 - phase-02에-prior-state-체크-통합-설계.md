---
id: TASK-130.1
title: phase 02에 prior-state 체크 통합 설계
status: Done
assignee: []
created_date: '2026-09-03 11:07'
updated_date: '2026-09-03 11:16'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
결정: 05_purge_asdf_core.sh와 동일하게 lt_prior_state_get()을 그대로 재사용한다. asdf_plugins_preexisting은 이 한 곳(02_remove_plugins.sh)에서만 소비되므로, 별도 lib.sh 헬퍼를 새로 만들지 않고 02 스크립트 내부에서 case 패턴 매칭(word-boundary용 앞뒤 공백 패딩)으로 플러그인 이름이 그 공백구분 목록에 포함되는지 직접 확인한다.

세이프 디폴트 정책(05와 동일 원칙 적용):
- lt_prior_state_get asdf_plugins_preexisting 이 성공(파일+키 존재) -> 목록에 있으면 사전존재(skip), 없으면 신규 설치분(remove). 목록이 빈 문자열이면 전부 remove(신규 머신의 정상 케이스).
- 실패(스냅샷 파일 없음 또는 키 없음) -> '알 수 없음'이므로 05와 동일하게 안전 기본값: 모든 플러그인을 사전존재로 간주하고 skip.

skip 시 lt_report skipped로 감사 로그에 남긴다 (05의 skipped 메시지와 동일 톤: '...looked pre-existing, or unconfirmed - not removed; see README').
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
phase 02가 05와 동일한 lt_prior_state_get() 헬퍼를 재사용하도록 설계 확정 (새 lib.sh 헬퍼 불필요, 02 내부 case 패턴 매칭). 세이프 디폴트: 스냅샷/키 없으면 전부 사전존재로 간주해 skip. 구현은 TASK-130.2에서 진행.
<!-- SECTION:FINAL_SUMMARY:END -->
