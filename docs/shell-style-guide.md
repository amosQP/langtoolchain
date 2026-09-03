# 셸 스타일 가이드 (Google Shell Style Guide 기반, POSIX sh로 조정)

원본: [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
(CC BY 3.0 라이선스, 원문 저작권은 Google 소유).

이 저장소는 TASK-71(m-5, 2026-08-27)에서 "시각적 규칙(들여쓰기/라인 길이/네이밍)은 Google
가이드를 그대로 따르되, Bash 전제 규칙(Bashism)은 POSIX sh 표준으로 대체한다"고 정책을
정했다. 이 문서는 그 정책을 실제로 참조 가능한 형태로 남겨둔 것이다 — Google 원문을 그대로
복붙하지 않고, 이 저장소에 실제로 적용되는 규칙만 정리했다.

## 그대로 따르는 것 (Google 원문과 동일)

- **들여쓰기**: 스페이스 2칸, 탭 금지(단 here-document 본문의 `<<-` 안쪽은 예외)
- **라인 길이**: 최대 80자. 넘으면 here-document나 내부 개행으로 분리. 파일 경로/URL처럼
  쪼갤 수 없는 긴 단어는 예외.
- **주석**: 파일 최상단에 목적을 설명하는 헤더 주석. 라이브러리 함수는 전부(길이 무관)
  Globals/Arguments/Outputs/Returns를 명시하는 헤더 주석. `TODO(식별자): 설명` 형식.
- **네이밍**: 함수/변수는 소문자+언더바, 상수/환경변수는 대문자+언더바이고 선언 즉시
  `readonly`/`export`. 파일명도 소문자+언더바.
- **`if`/`for`/`while`의 `; then`/`; do`는 같은 줄에**, `else`는 별도 줄, `fi`/`done`은
  여는 키워드와 세로로 정렬.
- **`case`**: 각 절 2칸 들여쓰기, 한 줄짜리 절은 `pattern) cmd ;;` 형태.
- **변수 확장**: `"${var}"`처럼 중괄호+따옴표를 기본으로 하되, 기존 코드와의 일관성을
  우선. 위치 매개변수 한 자리(`$1`)나 특수변수(`$?`, `$#`)는 중괄호 생략 허용.
- **따옴표**: 변수/명령치환/공백/셸 메타문자가 들어간 문자열은 항상 따옴표. 순수 정수
  리터럴만 예외.
- **`$(...)` 명령 치환**을 백틱보다 우선.
- **`eval` 회피**, **`local`로 함수-지역 변수 선언**(단, 명령 치환 결과를 담을 땐 `local x`
  선언과 대입을 분리 — `local x="$(cmd)"`는 `$?`가 `local`의 종료코드를 덮어씀).
- **함수는 파일 상단(상수 선언 다음)에 모아두고, 실행 흐름은 함수 정의 사이에 흩뿌리지
  않는다.**
- **일관성이 최우선**: 명확한 기술적 근거가 없으면 기존 코드 스타일을 따른다.

## POSIX sh로 대체한 것 (Bashism → POSIX, TASK-71 결정)

Google 가이드 자체는 "실행 파일은 반드시 bash"를 전제하지만, 이 저장소는 macOS 기본
`/bin/sh`(및 `dash`)에서도 그대로 동작해야 하므로 다음을 대체한다:

| Google 원문(Bash) | 이 저장소(POSIX sh) |
|---|---|
| `#!/bin/bash` | `#!/usr/bin/env sh` |
| `${BASH_SOURCE[0]}` | `$0` |
| `[[ … ]]` | `[ … ]` + 패턴 매칭이 필요하면 `case` |
| 프로세스 치환 `< <(cmd)` | 임시파일 기반 읽기 (`cmd > tmp; while read ... < tmp`) |
| bash 배열 `var=()`/`var+=()` | 위치 매개변수 `set --` |
| `=~` / `BASH_REMATCH` | `case`나 `grep`/`sed`/`cut` 조합 |
| `set -euo pipefail` | `set -eu` (`pipefail`은 dash가 파싱 자체를 못 함) |
| `&>file` | `>file 2>&1` |
| `local`(POSIX 미표준이지만 dash 포함 사실상 모든 POSIX 호환 셸이 지원) | 그대로 유지(전역변수 전환은 이득보다 리스크가 커서 기각, TASK-71) |
| `readarray`, `PIPESTATUS` | 사용 안 함(파이프 결과는 임시파일 경유로 우회) |
| `(( … ))` 산술 | 그대로 사용 가능(POSIX 표준, `$(( … ))`/`(( … ))` 모두 dash에서 동작) |

추가로 TASK-71 검증 중 발견한 함정: `:`, `.`, `eval`, `exec`, `exit`, `export`, `readonly`,
`return`, `set`, `shift`, `times`, `trap`, `unset`, `break`, `continue` 같은 POSIX
"특수 내장명령"은 리다이렉션이 실패하면 `set -e`/`||`와 무관하게 비대화형 셸을 무조건
즉시 종료시킨다(dash가 이를 정확히 구현). 예: `: < /dev/tty`(tty 존재 확인용 관용구)가
dash에서 스크립트를 죽였다 — `true < /dev/tty`(특수 내장명령 아님)로 교체.

## 검증

- `shellcheck -s sh <file>` — 신규 경고 0건이 기준(SC1091/SC3043은 이 저장소가 이미
  받아들인 베이스라인, README 참고).
- `dash -n <file>` — 문법 검증.
- `shellspec --shell dash`로 전체 스위트를 강제 실행 — bash 실행과 별개로 dash에서도
  통과해야 함.
