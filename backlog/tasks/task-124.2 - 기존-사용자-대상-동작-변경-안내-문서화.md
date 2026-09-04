---
id: TASK-124.2
title: 기존 사용자 대상 동작 변경 안내 문서화
status: Done
assignee: []
created_date: '2026-08-30 12:01'
updated_date: '2026-09-03 01:18'
labels: []
dependencies:
  - TASK-124.1
parent_task_id: TASK-124
type: docs
ordinal: 157000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이 변경 전 버전의 uninstall.sh를 이미 써본 적 있는 사용자, 또는 이 변경 이후에도 스냅샷 없이 uninstall을 실행하게 될 사용자를 위해 README/CHANGELOG에 동작 변경을 안내한다: "이제 uninstall은 langtoolchain 설치 전부터 있던 asdf 상태를 보존하려 시도하며, 스냅샷이 없으면 안전을 위해 삭제를 건너뛰고 수동 정리 방법을 안내한다"는 내용.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 README(한/영 양쪽)에 uninstall 동작 변경이 명시됨
<!-- AC:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
readme.md/readme.en.md의 '설치/제거되는 것' 섹션에서 'uninstall은 asdf 자체를 통째로 지우기 때문에 예외' 서술을 새 동작(설치 시점 스냅샷상 $HOME/.asdf가 이미 있었거나 확인 불가하면 삭제를 건너뛰고 경고)으로 교체하고, '⚠️ 동작 변경 안내(m-13)' 콜아웃을 양쪽 언어에 추가: 이 기능 이전에 설치한 사용자는 스냅샷이 없어 uninstall이 기본적으로 $HOME/.asdf 삭제를 스킵하게 되며, 완전 삭제를 원하면 안내대로 rm -rf ~/.asdf를 직접 실행해야 한다는 내용. 부수적으로 spec 예제 수 증가(132→143)를 반영해 '테스트 검증의 한계' 절의 숫자도 갱신.
<!-- SECTION:FINAL_SUMMARY:END -->
