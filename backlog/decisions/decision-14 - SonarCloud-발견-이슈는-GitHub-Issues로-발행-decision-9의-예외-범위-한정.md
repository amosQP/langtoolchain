---
id: decision-14
title: SonarCloud 발견 이슈는 GitHub Issues로 발행 (decision-9의 예외, 범위 한정)
date: '2026-09-04'
status: accepted
---
## Context

decision-9(2026-09-03)에서 "GitHub Issues/gh CLI를 이 저장소의 태스크 관리 흐름에
도입하지 않는다"고 결정했다 — backlog.md를 유일한 태스크 소스로 유지해서 여러 시스템
간 정합성 문제(decision ID 충돌 등, m-14/m-16에서 실제로 겪음)를 피하려는 목적이었다.

TASK-152(decision-13, SonarQube Cloud 채택) 진행 중 사용자가 "소나클라우드 이슈가
깃헙 이슈로 들어와야되"라고 요청했다. decision-9와 충돌하는지 확인차 되물었고, 사용자
답변: **"이건 다른 케이스야. 소나큐브는 이슈로 발행한다. 이 파이프라인만 가는거"** —
즉 backlog.md 태스크 관리 흐름을 GitHub Issues로 바꾸는 게 아니라, SonarCloud가 찾은
코드 품질 이슈**만** GitHub Issues로 발행하는 별도의 좁은 파이프라인이라는 뜻이다.

## Decision

**decision-9는 그대로 유지한다** — 이 저장소의 태스크 관리(backlog task)는 계속
backlog.md 하나로만 한다. GitHub Issues를 일반적인 이슈 트래커/태스크 관리 도구로
도입하는 게 아니다.

**단, SonarCloud가 찾은 코드 품질 이슈는 예외적으로 GitHub Issues로 발행한다.** 이건
SonarCloud → GitHub Issues라는 한 방향, 한 종류의 파이프라인에만 한정된다:
- SonarCloud 자체 발견물(코드 스멜, 버그, 보안 핫스팟 등)만 대상. backlog task나
  decision을 GitHub Issues로 옮기거나 미러링하지 않는다.
- 반대 방향(GitHub Issues → backlog task 전환) 워크플로도 만들지 않는다 — TASK-137이
  다루려다 기각했던 바로 그 범용 양방향 연동은 여전히 안 한다.
- SonarCloud가 만드는 GitHub Issue에는 식별 가능한 라벨(예: `sonarcloud`)을 붙여서
  일반 backlog 기반 작업과 시각적으로 구분되게 한다.

## Consequences

- TASK-152(SonarCloud CI 통합 스캐폴딩) 범위에 "SonarCloud 이슈 -> GitHub Issues 발행"
  자동화를 포함시킨다 — SonarCloud 공식 GitHub 연동(PR 데코레이션)은 이 발행 파이프라인을
  대체하지 않고 별개로 계속 동작한다(PR 코멘트는 코멘트대로, 이슈 발행은 이슈 발행대로).
- SonarCloud에 네이티브 "GitHub Issues로 내보내기" 기능이 없으므로(2026-09-04 확인),
  SonarCloud REST API(`api/issues/search`, organization=amosqp, project=
  amosQP_langtoolchain)로 이슈를 가져와서 `gh issue create`로 발행하는 커스텀 자동화
  (GitHub Actions 워크플로)를 만들어야 한다.
- 이 자동화가 gh CLI를 쓴다고 해서 decision-9가 뒤집히는 건 아니다 — decision-9는 "태스크
  관리 흐름"에 대한 것이고, 이건 "외부 도구(SonarCloud) 발견물의 알림 채널"이라 성격이
  다르다.
- 중복 발행 방지(같은 SonarCloud 이슈로 매번 새 GitHub Issue가 안 생기게) 로직이
  구현에 필요하다 — 예: SonarCloud 이슈 key를 GitHub Issue 본문/제목에 기록해두고
  기존 이슈 검색으로 중복 체크.
