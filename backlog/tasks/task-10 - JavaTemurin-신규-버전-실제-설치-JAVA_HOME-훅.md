---
id: TASK-10
title: Java(Temurin) 신규 버전 실제 설치 + JAVA_HOME 훅
status: Done
assignee: []
created_date: '2026-08-24 08:05'
updated_date: '2026-08-27 20:53'
labels:
  - test
  - runtime
dependencies: []
parent_task_id: TASK-43
priority: medium
ordinal: 10000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
asdf install java로 신규 Temurin 버전을 설치하고, set-java-home 훅을 통해 새 셸에서 JAVA_HOME이 정확히 설정되는지 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 새 터미널에서 echo $JAVA_HOME이 설치된 java 버전의 정확한 경로를 가리킨다
<!-- AC:END -->

## Comments

<!-- COMMENTS:BEGIN -->
created: 2026-08-27 20:53
---
GitHub Actions 워크플로 .github/workflows/e2e-verify.yml, run https://github.com/amosQP/langtoolchain/actions/runs/33114765195 (전부 success) — asdf install java temurin-25.0.2+10.0.LTS 실제 설치 성공, java -version으로 검증됨. JAVA_HOME 훅은 04_configure_shell_env.sh의 rc 파일 기록으로 커버(실제 로그인 셸 PATH 확인은 TASK-18).
---
<!-- COMMENTS:END -->
