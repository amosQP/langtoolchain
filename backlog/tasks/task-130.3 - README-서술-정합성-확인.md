---
id: TASK-130.3
title: README 서술 정합성 확인
status: Done
assignee: []
created_date: '2026-09-03 11:07'
updated_date: '2026-09-03 11:22'
labels: []
dependencies:
  - TASK-130.2
parent_task_id: TASK-130
type: task
ordinal: 184000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
readme.md/readme.en.md의 uninstall 관련 서술("langtoolchain이 설치하지 않은 asdf
플러그인은 건드리지 않는다" 류)이 이제 실제 동작(phase 02+05 둘 다 prior-state를 지킴)과
일치하는지 확인하고, TASK-124.2가 남긴 "기존 사용자 대상 동작 변경 안내" 문구도 이 수정으로
범위가 넓어졌다면 갱신한다. 코드 변경 없음.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
readme.md/readme.en.md의 uninstall 서술을 phase 02+05 둘 다 prior-state를 지키는 실제 동작과 맞춤. 기존 문구('다른 asdf 플러그인은 uninstall 쪽에서든 손대지 않는다')는 의도된 약속을 서술한 것이었으나 TASK-130 수정 전에는 실제로 지켜지지 않았음 — 이제는 코드가 그 약속을 실제로 지킴. 동작 변경 안내(m-13) 콜아웃 박스도 '~/.asdf/ 전체 삭제'뿐 아니라 '개별 asdf 플러그인 삭제'도 스냅샷 없을 때 동일하게 skip된다는 점을 명시하도록 갱신(TASK-124.2가 남긴 문구의 범위가 TASK-130으로 넓어짐). 부수적으로 spec 개수 언급(165->168)도 이번에 추가한 3개 예제를 반영해 갱신. 코드 변경 없음(문서만).
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
readme.md/readme.en.md 갱신 완료 - uninstall이 이제 개별 플러그인 삭제(phase 02)와 데이터 디렉토리 전체 삭제(phase 05) 양쪽 모두에서 설치 시점 스냅샷을 존중한다는 사실을 반영. m-13 동작 변경 안내 문구도 범위 확장. spec 개수 165->168 갱신. 코드 변경 없음.
<!-- SECTION:FINAL_SUMMARY:END -->
