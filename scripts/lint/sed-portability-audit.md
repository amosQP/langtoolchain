# sed 사용 지점 BSD/GNU 이식성 감사 (TASK-126)

이 저장소는 macOS 전용 도구지만, `sed` 문법이 BSD sed(macOS 기본 `/bin/sed`)와
GNU sed 사이에서 갈라지는 지점(특히 `-i` in-place 옵션의 인자 방식)이 있어
예방적으로 전수 감사한다.

## TASK-126.1: 전수 목록화

`grep -rn '\bsed\b'`로 저장소 전체(scripts/, spec/, .github/, install.sh,
uninstall.sh)를 검색한 결과, 실제 sed **호출**은 2곳뿐이다(그 외 매치는
전부 sed를 언급하는 주석). `.github/workflows/`와 `spec/`에는 sed 호출이
전혀 없다.

| # | 파일:줄 | 호출 | 옵션 | 컨텍스트 |
|---|---|---|---|---|
| 1 | `scripts/lib.sh:601` | `sed -n 's/[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\(\.[0-9][0-9]*\)*\).*/\1/p'` | `-n`, BRE(확장 정규식 아님, `-E`/`-r` 없음), in-place 아님(읽기 전용, 파이프 입력) | `version_core()` — 버전 문자열에서 X.Y[.Z] 숫자만 추출 |
| 2 | `scripts/uninstall/03_clean_env_vars.sh:61` | `sed -E -i '.bak' "$@" "$rc"` | `-E`(확장 정규식), `-i '.bak'`(in-place, 백업 접미사 `.bak`를 **별도 인자**로 전달), `"$@"`는 동적으로 조립된 다수의 `-e` 표현식 | `03_clean_env_vars.sh` — rc 파일에서 이 도구가 추가한 줄들을 제거 |

주석(scripts/lib.sh:24, 147, 149 / scripts/install/04_configure_shell_env.sh:18
/ scripts/uninstall/03_clean_env_vars.sh:19,22,26-38,40-45)은 sed를
언급하지만 호출이 아니므로 감사 대상에서 제외. 특히 `03_clean_env_vars.sh`의
주석은 이미 TASK-56(BSD sed의 `\|` 대체 미지원 버그)을 근거로 `-E`를 쓰는
이유와 `-i`에 빈 백업 접미사가 아니라 명시적 `.bak`를 주는 이유를 설명하고
있어, 이 지점이 과거 한 차례 BSD/GNU sed 이식성 버그의 직접적 수정
지점이었음을 보여준다.
