---
id: TASK-145.3
title: install.sh/uninstall.sh의 clone_pinned()에 타임아웃 추가
status: In Progress
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 14:01'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 215000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh와 uninstall.sh가 각자 갖고 있는 clone_pinned() 함수의
git fetch -q --depth 1 origin "$1"에 타임아웃이 전혀 없다. TASK-138이 lt_run_with_timeout()
을 만든 바로 그 이유(DNS/TCP/TLS 핸드셰이크 블랙홀)에 그대로 노출돼 있다 — curl|sh
자체가 무한정 멈출 수 있음. 다만 이 두 파일은 "저장소가 아직 로컬에 없는 최초 진입점"이라
scripts/lib.sh를 source할 수 없다(파일 자체 주석에 이미 명시됨) — lt_run_with_timeout()과
동일한 워치독 로직을 이 두 파일에 각자 인라인으로 복제하거나, 더 단순한 대안(timeout 커맨드
가용성 재확인 등)을 검토한다. install.sh/uninstall.sh 둘 다 동일하게 수정해야 한다(두
파일이 이 함수의 중복 사본을 각자 갖고 있음).
<!-- SECTION:DESCRIPTION:END -->
