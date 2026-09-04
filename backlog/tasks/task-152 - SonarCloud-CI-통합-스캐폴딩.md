---
id: TASK-152
title: SonarCloud CI 통합 스캐폴딩
status: To Do
assignee: []
created_date: '2026-09-04 20:02'
labels: []
milestone: m-16
dependencies: []
references:
  - decision-13
  - TASK-136
priority: low
type: task
ordinal: 225000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
decision-13(SonarQube Cloud 채택) 후속 구현. GitHub Actions 워크플로 +
sonar-project.properties 스캐폴딩을 추가해서 PR/push마다 SonarCloud 분석이 돌게 한다.

**중요: 이 태스크는 GitHub Actions 워크플로/설정 파일 스캐폴딩까지만 다룬다.**
SonarCloud 계정 생성과 SONAR_TOKEN 발급은 이 저장소를 소유한 사용자가 SonarCloud
웹사이트(sonarcloud.io)에서 GitHub 계정으로 직접 로그인해서 이 저장소를 프로젝트로
등록하고 토큰을 발급해야 한다 — AI 에이전트가 대신 할 수 없는 수동 단계다. 이 태스크를
맡는 에이전트/사람은:
1. sonar-project.properties 작성 (projectKey, organization 등 — 정확한 값은 사용자가
   SonarCloud에서 프로젝트 등록 후 알려줘야 함, 그전까진 플레이스홀더로 남겨둘 것)
2. .github/workflows/에 SonarCloud 분석 워크플로 추가(공식 SonarSource GitHub Action
   사용, secrets.SONAR_TOKEN 참조)
3. README에 "SonarCloud 배지 + SONAR_TOKEN 설정 안내" 추가
4. 실제로 SONAR_TOKEN이 등록되기 전까진 이 워크플로가 실패할 것이므로, 그 사실과
   사용자가 해야 할 수동 단계(SonarCloud 가입 -> 프로젝트 등록 -> 토큰 발급 -> GitHub
   저장소 Settings -> Secrets에 SONAR_TOKEN 등록)를 태스크 완료 시 명확히 안내한다.
<!-- SECTION:DESCRIPTION:END -->
