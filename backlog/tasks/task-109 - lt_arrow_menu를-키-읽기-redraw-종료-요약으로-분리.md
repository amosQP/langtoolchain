---
id: TASK-109
title: lt_arrow_menu()를 키 읽기/redraw/종료 요약으로 분리
status: Done
assignee: []
created_date: '2026-08-30 04:51'
updated_date: '2026-08-30 04:51'
labels: []
milestone: m-8
dependencies: []
type: task
ordinal: 124000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
00_select.sh의 lt_arrow_menu()가 raw-mode fallback + 키 읽기 루프(ESC 시퀀스 파싱 포함) + 종료 후 한 줄 요약 collapse까지 한 함수에 섞여있던 걸 lt_read_menu_key()(키 하나 읽고 UP/DOWN/ENTER/숫자로 분류)와 lt_collapse_menu()(블록 지우고 한 줄 요약)로 분리. before/after를 사용자에게 실제 원문 그대로 보여주고 승인받은 뒤 적용.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
적용 완료. lt_read_menu_key(n)는 키 하나 raw로 읽어서 UP/DOWN/ENTER/숫자/OTHER로 분류만 하고, lt_collapse_menu(question, chosen, n)은 블록 지우고 요약 줄만 그림. lt_arrow_menu()는 이제 '읽고(lt_read_menu_key) -> 반응하고 -> 그리고(lt_draw_arrow_menu) -> 확정 시 접기(lt_collapse_menu)' 오케스트레이션만 함. ENTER/숫자 분기에서 stty 복원을 각 break 지점에 넣어야 해서 약간의 중복이 생긴 트레이드오프는 사용자에게 미리 설명함.
<!-- SECTION:NOTES:END -->
