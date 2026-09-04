---
id: TASK-145.4
title: asdf plugin add/update에 타임아웃 추가
status: In Progress
assignee: []
created_date: '2026-09-04 08:56'
updated_date: '2026-09-04 14:09'
labels: []
dependencies: []
parent_task_id: TASK-145
type: task
ordinal: 216000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/02_install_plugins.sh의 retry 3 5 run asdf plugin add "$plugin"과
asdf plugin update --all이 내부적으로 git clone/fetch를 실행하는데 타임아웃이 없다.
lt_run_with_timeout()으로 감싸서 멈춘 연결에서도 retry가 실제로 재시도할 기회를 갖게 한다.
<!-- SECTION:DESCRIPTION:END -->
