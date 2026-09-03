# 저장소 내 다운로드/설치 지점 전수 매핑 (TASK-116.2)

TASK-116.1([download-integrity-techniques.md](download-integrity-techniques.md))에서 정리한
검증 기법들을, 이 저장소가 실제로 원격 콘텐츠를 받아오는 모든 지점에 매핑한 문서. 2026-08-30
Explore agent 조사를 2026-09-03 재검증하여 확정.

각 지점은 **다운로드되는 것 / 현재 검증 수준 / 분류**로 정리한다. 분류는 두 가지뿐:

- **하드닝 대상** — 이 저장소가 직접 검증 로직을 추가할 수 있고, TASK-117 하위 태스크로
  실제 구현/결정을 남긴다.
- **통제 밖(문서화만)** — 이 저장소가 검증할 수 없거나(업스트림 내부 로직) 검증 비용 대비
  이득이 낮다고 판단한 경우 — TASK-117.4에서 신뢰 경계로 명시하는 것이 유일한 조치.

## 지점 목록

| # | 파일:라인 | 다운로드되는 것 | 현재 검증 수준 | 분류 | 관련 태스크 |
|---|---|---|---|---|---|
| 1 | `install.sh:70` | 이 저장소 자신의 self-clone (`git clone --depth 1 --branch "$BRANCH"`) | 없음 — 브랜치 HEAD를 그대로 신뢰(플로팅 참조) | 하드닝 대상 | TASK-117.1, TASK-117.6 |
| 2 | `uninstall.sh:47` | 위와 동일한 self-clone (install.sh와 구조적으로 대칭, `REPO_URL`/`BRANCH` 값도 손으로 동기화됨) | 없음 — 1번과 동일 | 하드닝 대상 | TASK-117.1, TASK-117.6 (양쪽 파일 모두 반영 필요) |
| 3 | `scripts/install/01_bootstrap_asdf.sh:57` | Homebrew 공식 설치 스크립트(`curl -fsSL .../Homebrew/install/HEAD/install.sh`)를 받아 즉시 `bash`로 실행 | 없음 — 전형적인 `curl \| bash`, 체크섬/서명 대조 없음 | 하드닝 대상 | TASK-117.2 |
| 4 | `scripts/install/01_bootstrap_asdf.sh:82` | `brew install asdf` (asdf 바이너리 자체) | 위임 — Homebrew의 내부 bottle 서명/체크섬 체계 | 통제 밖(문서화만) | TASK-117.4 |
| 5 | `scripts/install/02_install_plugins.sh:55` | `asdf plugin add "$plugin"` (내부적으로 asdf-nodejs/asdf-python 등 플러그인 저장소를 git clone) | 없음 — 커밋 SHA 미고정, 항상 플러그인 저장소의 최신 HEAD | 검토 대상 (고정 여부는 결정 사항) | TASK-117.3 |
| 6 | `scripts/install/03_install_system_deps.sh:18` | `brew install $LT_BUILD_DEPS` (openssl/readline/sqlite3/xz/zlib/tcl-tk) | 위임 — Homebrew bottle 서명 | 통제 밖(문서화만) | TASK-117.4 |
| 7 | `scripts/install/05_install_runtimes.sh:39` | `asdf install "$plugin" "$version"` (실제 언어 런타임 소스/바이너리) | 위임 — 각 asdf 플러그인 내부 로직(플러그인마다 다르며 이 저장소가 관여 불가) | 통제 밖(문서화만) | TASK-117.4 |
| 8 | `scripts/install/06_set_globals.sh:70-73` | `asdf reshim` | 해당 없음 — 원격 다운로드가 아니라 이미 로컬에 설치된 바이너리에 대한 shim 재생성(asdf 내부 로직에 위임) | 통제 밖(문서화만, 다운로드 지점 아님) | — |
| 9 | `scripts/install/07_validate.sh:46-57` | 해당 없음 — 다운로드가 아니라 이미 설치된 바이너리의 PATH 해석 결과를 점검(다른 shim에 가려지는지) | 이 저장소가 직접 통제하는 유일한 "shim 보안" 검증 지점, 현재는 WARN만(FAIL 아님) | 하드닝 대상 (검증 로직이 아니라 정책 재평가) | TASK-117.5 |

## 관찰: 이 저장소가 "직접" 검증할 수 있는 지점은 제한적

8개 지점 중 원격 콘텐츠를 실제로 받아오는 곳은 7곳(#1~#7, #8/#9는 다운로드 자체가 아님)이고,
그중 이 저장소가 직접 검증 로직을 추가할 수 있는 곳은 **#1/#2(self-clone)**, **#3(Homebrew
설치 스크립트)**, **#5(asdf 플러그인 소스, 검토 후 결정)** 세 곳뿐이다. 나머지(#4, #6, #7)는
전부 Homebrew/asdf라는 상위 신뢰 주체에게 위임돼 있으며, 이 저장소의 코드 수준에서 손댈 지점이
없다 — 이 위임 관계 자체를 명시적으로 문서화하는 것(TASK-117.4)이 유일하게 유효한 조치다.

#9(PATH 섀도잉 체크)는 다운로드 검증은 아니지만, "이 저장소가 통제할 수 있는 유일한 shim
보안 지점"이라는 점에서 m-11 스코프에 포함된다(TASK-117.5).

## 공용 삽입 지점

`scripts/lib.sh`의 `run()`/`retry()`는 모든 하드닝 대상(#1~#3)이 공통으로 거치는 래퍼이지만,
현재는 dry-run 게이트/재시도 로직만 있고 무결성 검증 개념이 없다 — TASK-117 구현 시 여기에
직접 검증 함수를 추가하기보다는(래퍼가 모든 호출자에 동일한 검증을 강제하면 self-clone처럼
다운로드 성격이 다른 지점마다 별도 파라미터가 필요해져 오히려 복잡해짐), 각 하드닝 대상
파일에서 국소적으로 처리하는 편이 이 저장소의 "역할별로 분리된 phase 스크립트" 설계 원칙과
더 맞는다는 것이 이 조사의 결론이다. 실제 구현 시 TASK-117 하위 태스크에서 이 판단을 재검토할
수 있다.

이전 문서: [download-integrity-techniques.md](download-integrity-techniques.md) (TASK-116.1)
