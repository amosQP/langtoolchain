---
id: TASK-152
title: SonarCloud CI 통합 스캐폴딩
status: To Do
assignee: []
created_date: '2026-09-04 20:02'
updated_date: '2026-09-05 03:06'
labels: []
milestone: m-16
dependencies: []
references:
  - decision-14
priority: low
type: task
ordinal: 225000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
decision-13(SonarQube Cloud 채택) 후속 구현. GitHub Actions 워크플로 +
sonar-project.properties 스캐폴딩을 추가해서 PR/push마다 SonarCloud 분석이 돌게 한다.

**확인된 값** (2026-09-04, SonarCloud 공개 API로 실측 확인, 사용자가 이미 가입/프로젝트
등록 완료):
- organization: `amosqp`
- projectKey: `amosQP_langtoolchain`

**범위 (decision-13 + decision-14 반영)**:
1. `sonar-project.properties` 작성 (projectKey=amosQP_langtoolchain,
   organization=amosqp)
2. `.github/workflows/`에 SonarCloud 분석 워크플로 추가(공식 SonarSource GitHub
   Action, `secrets.SONAR_TOKEN` 참조) — 실제 SONAR_TOKEN 발급/GitHub Secrets 등록은
   사용자가 직접 해야 하는 수동 단계(SonarCloud 웹사이트에서 발급)이니 명확히 안내
3. **SonarCloud 이슈 → GitHub Issues 발행 파이프라인 (decision-14, 신규 범위)**:
   SonarCloud에 네이티브 export 기능이 없으므로, SonarCloud REST API
   (`api/issues/search?organization=amosqp&componentKeys=amosQP_langtoolchain`)로
   이슈를 가져와서 `gh issue create`로 발행하는 GitHub Actions 워크플로를 만든다.
   - `sonarcloud` 라벨을 붙여서 일반 backlog 기반 작업과 구분
   - 이미 발행된 SonarCloud 이슈는 중복 발행하지 않도록 이슈 key 기반 중복 체크
   - 이 파이프라인은 SonarCloud 발견물 전용이다 — backlog task/decision을 GitHub
     Issues로 옮기거나 그 반대로 옮기는 건 여전히 범위 밖(decision-9 유지)
4. README에 SonarCloud 배지 + SONAR_TOKEN 설정 안내 + "코드 품질 이슈는 GitHub
   Issues에서 확인 가능" 안내 추가
<!-- SECTION:DESCRIPTION:END -->
