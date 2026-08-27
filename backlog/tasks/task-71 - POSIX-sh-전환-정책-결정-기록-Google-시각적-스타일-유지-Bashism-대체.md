---
id: TASK-71
title: POSIX sh 전환 정책 결정 기록 (Google 시각적 스타일 유지 + Bashism 대체)
status: To Do
assignee: []
created_date: '2026-08-27 14:40'
labels:
  - code-quality
  - posix
  - policy
milestone: m-5
dependencies: []
priority: high
type: chore
ordinal: 71000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
정책: 기본 포맷은 Google Shell Style Guide를 벤치마킹한다 — 들여쓰기(스페이스 2칸), 라인 길이 제한(80~100자), 변수명(소문자+언더바), 상수명(대문자+언더바), 함수명(소문자+언더바) 같은 시각적 규칙은 Google 스타일을 그대로 따른다. 다만 호환성 레이어는 POSIX로 수정한다: Google 가이드 자체는 Bash를 기본 전제로 하므로, 이 저장소처럼 POSIX(sh) 환경에서 돌아가야 하는 경우 Google 문서에서 'Bash 전용 문법(Bashisms)'을 다루는 부분만 POSIX 표준 규칙으로 대체한다.

저장소 전체를 grep으로 스캔해서 실제로 제거해야 할 Bashism 목록을 확정했다:
1. shebang: #!/usr/bin/env bash → #!/usr/bin/env sh (전체 19개 파일)
2. ${BASH_SOURCE[0]} → $0 (전체 19개 파일 — 가장 광범위하게 쓰이는 bashism)
3. [[ ]] → [ ] + 패턴 매칭이 필요한 곳은 case문으로 (36곳, 여러 파일)
4. 프로세스 치환 < <(cmd) → 임시파일 기반 읽기로 재작성 (10개 파일 — 거의 모든 phase 스크립트의 핵심 루프 패턴)
5. bash 배열(var=(), var+=()) → 위치 매개변수(set --)로 대체 (2개 파일: install/main.sh의 SELECT_OPTS, uninstall/03_clean_env_vars.sh의 sed_args)
6. BASH_REMATCH / =~ 정규식 매칭 → POSIX 호환 대체 (lib.sh의 version_core() 1곳)
7. local: POSIX 표준에 정의된 키워드는 아니지만 dash를 포함한 사실상 모든 POSIX 호환 셸이 지원하는 사실상 표준 확장이라 유지하기로 결정(전역변수로 바꾸는 건 이득 대비 리스크가 너무 큼) — 이 결정 자체를 여기 기록해서 나중에 이견이 있으면 재검토.

검증은 macOS 자체 /bin/sh(사실 bash 기반이라 bashism을 relaxed하게 허용함, TASK-60에서 이미 확인됨)로는 부족하므로, 진짜 POSIX 셸인 /bin/dash(macOS에 기본 내장)로 각 스크립트를 직접 실행해 검증한다.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 정책이 이 태스크에 기록되고, 실제 저장소에 적용된 Bashism 목록과 각각의 POSIX 대체 방식이 명시된다
- [ ] #2 local 키워드를 유지하기로 한 결정과 그 근거가 기록된다
<!-- AC:END -->
