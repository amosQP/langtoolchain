---
id: decision-13
title: '정적분석 도구 채택: SonarQube Cloud, CodeQL은 shell 미지원으로 기각'
date: '2026-09-04'
status: accepted
---
## Context

TASK-136(m-16)에서 SonarQube/CodeQL 같은 코드 품질 정적분석 도구를 이 저장소(POSIX sh
전용, public GitHub 저장소, 개인 툴링)에 도입할 만한지 조사했다. 사용자가 사전에
"소나큐브 달자, CodeQL과 비교해봐, sh 지원해야 돼, 다른 도구도 필요하면 찾아와"라고
방향을 줬다 — sh 지원이 필수 조건이라는 전제 하에 SonarQube 채택을 원함.

TASK-136.1에서 공식 문서로 실측 확인한 결과:

- **CodeQL**: 공식 지원 언어(C/C++, C#, Go, Java/Kotlin, JavaScript/TypeScript,
  Python, Ruby, Rust, Swift)에 Shell/Bash가 전혀 없다. GitHub Advanced Security
  유료 플랜이어도 마찬가지 — 비용이 아니라 애초에 셸을 분석 대상으로 만들지 않는다.
- **SonarQube Cloud(호스팅) Free 플랜**: Shell이 정식 지원 언어(베타 아님)이고,
  2026-01 신설 Free 플랜은 public repo에 LOC 제한 없이 무료 — 이 저장소는 public
  repo이므로 조건 충족. 다만 이 shell 분석기는 2025-10-03 베타 출시 → 당일 철회 →
  2025-10-15 재출시된 1년 미만 신생 기능이며, POSIX `[` vs `[[` 오탐 등 보고된 문제가
  있다.
- **SonarQube Server 셀프호스팅 Community Build(무료)**: Shell 미지원 — Developer
  Edition 이상(유료)부터 지원. 셀프호스팅 무료판으로는 sh 지원 조건을 못 만족한다.
- **기타 후보**: Semgrep(bash 파서 실험적, 무료, shellcheck 보완용), shellharden
  (auto-fixer, 린터 아님), Bearer(shell 미지원), Trivy(코드 로직 분석 도구 아님,
  카테고리 다름) — 전부 SonarQube를 대체할 만한 1차 후보는 아니고, 기존 shellcheck +
  `scripts/lint/check-hardcoded-paths.sh`를 대체하지도 않는다.

## Decision

**SonarQube Cloud(호스팅) + Free 플랜을 도입한다. CodeQL은 shell을 전혀 지원하지
않아 기각한다. 셀프호스팅 SonarQube Server(Community Build)는 shell 미지원이라
선택지에서 제외한다.**

기존 shellcheck(-s sh) + 자체 lint(`scripts/lint/check-hardcoded-paths.sh`)는
그대로 유지 — SonarQube Cloud는 이를 대체하는 게 아니라 추가하는 레이어다.

## Consequences

- CI 통합 스캐폴딩은 별도 태스크(TASK-152)로 분리한다 — 이 결정 태스크 자체는 채택
  여부까지만 다룬다.
- SonarQube Cloud 사용을 시작하려면 사용자가 직접 SonarCloud 계정을 만들고
  `SONAR_TOKEN`을 발급해서 이 저장소의 GitHub Actions secret으로 등록해야 한다 —
  이건 이 세션(에이전트)이 대신 할 수 없는 수동 단계다.
- shell 분석기가 1년 미만 신생 기능이라 오탐(false positive)이 나올 수 있다 — 처음
  도입 시 결과를 그대로 다 받아들이지 말고, 오탐으로 보이는 항목은 개별 검토 후
  quality profile에서 조정하거나 무시 처리한다.
- SonarCloud의 shell 분석 자체가 향후 정책 변경(Free 플랜 축소, 언어 지원 제외 등)
  으로 바뀔 수 있다 — 그 경우 이 decision을 재검토한다.
