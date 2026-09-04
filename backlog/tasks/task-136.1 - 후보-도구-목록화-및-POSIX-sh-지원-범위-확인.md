---
id: TASK-136.1
title: 후보 도구 목록화 및 POSIX sh 지원 범위 확인
status: Done
assignee: []
created_date: '2026-09-03 11:31'
updated_date: '2026-09-04 20:01'
labels: []
dependencies: []
parent_task_id: TASK-136
type: task
ordinal: 193000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
SonarQube(Community/Developer 에디션별 shell 분석 지원 여부), CodeQL(지원 언어 목록에
shell 포함 여부), Semgrep(커스텀 룰로 shell 패턴 매칭 가능한지), 기타(shellharden 등)를
조사해 후보 목록을 만든다. 각 도구가 실제로 POSIX sh(.sh, bash 특수문법 없음)에 대해
shellcheck를 넘어서는 유의미한 탐지를 제공하는지, 아니면 사실상 shellcheck 재포장 수준인지
확인한다. 무료/개인 프로젝트(이 저장소는 public이지만 "개인 툴링") 사용 가능 여부(가격
정책)도 함께 조사.
<!-- SECTION:DESCRIPTION:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
## 조사 결과 (2026-09-04, 공식 문서 확인 완료)

**CodeQL — shell 전면 미지원 (모든 플랜/에디션 공통, 확정)**
공식 지원 언어는 C/C++, C#, Go, Java/Kotlin, JavaScript/TypeScript, Python, Ruby,
Rust, Swift뿐. Shell/Bash는 어떤 형태로도 지원 목록에 없음. GitHub Advanced Security
유료 플랜이어도 마찬가지 — 비용 문제가 아니라 애초에 셸을 분석 대상으로 만들지 않음.
→ 기각.

**SonarQube — "어디서" 쓰느냐에 따라 갈림 (핵심 발견)**
- SonarQube Cloud(호스팅) Free 플랜: Shell이 정식 지원 언어 목록에 있음(베타 아님 —
  베타는 PowerShell뿐), Bash/POSIX sh 공식 지원, 21개 룰. 2026-01 신설 Free 플랜은
  public repo에 대해 LOC 제한 없이 무료 — 이 저장소는 public repo이므로 조건 충족.
  Enterprise 전용 언어는 ABAP/Apex/COBOL/JCL/PL·I/RPG뿐, Shell은 거기 없음 → Free
  플랜에서 shell 분석 실제로 됨.
  - 주의: 이 분석기는 2025-10-03 베타 출시 → 당일 긴급 철회 → 2025-10-15 재출시된
    1년 미만 신생 기능. 보고된 문제: POSIX `[` vs `[[` 오탐, 얕은 clone에서 기존
    코드가 "신규 코드"로 오분류. GA 전환 후 개선 여부는 미검증.
- SonarQube Server 셀프호스팅 Community Build(무료): Shell 미지원 — 공식 언어
  목록에 C#/CSS/Docker/Go/HTML/Java/JavaScript/Kotlin/PHP/Python/Ruby/Rust/Scala/
  Terraform/TypeScript/VB.NET/XML 등만 있고 Shell/C/C++/YAML/JSON은 전부 빠짐.
  Shell은 Developer Edition 이상(유료)부터.

**결론**: sh 지원 필수조건은 "SonarQube Cloud + Free 플랜(public repo)" 경로로만
충족되고, 셀프호스팅 무료판으로는 충족 안 됨. 이 저장소는 public repo라 SonarQube
Cloud Free가 실제 쓸 수 있는 등급 — 조건 만족.

**기타 후보**

| 도구 | POSIX sh 지원 | 비용 | 비고 |
|---|---|---|---|
| Semgrep | 실험적(bash 파서 ~92% 파싱 성공률), 커뮤니티 룰 존재 | 무료(OSS) | shellcheck 대체 아닌 보완용 |
| shellharden | POSIX sh 대상, 특정 클래스만 자동교정 | 무료 | 린터 아닌 auto-fixer |
| Bearer | 미지원(Go/Java/JS/TS/PHP/Python/Ruby만) | — | 후보 아님 |
| Trivy | 코드 로직 분석 아님(컨테이너/IaC/시크릿/취약점) | 무료 | 카테고리 다름, 보완재 |
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
CodeQL(전 플랜 shell 미지원, 확정)과 SonarQube(Cloud+Free는 shell 지원, 셀프호스팅 Community Build는 미지원)를 공식 문서로 실측 확인. 이 저장소가 public repo라 SonarQube Cloud Free 조건 충족. Semgrep/shellharden/Bearer/Trivy도 보조 후보로 검토, 표로 정리. 조사 결과는 task notes 참고.
<!-- SECTION:FINAL_SUMMARY:END -->
