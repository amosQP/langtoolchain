#### langtoolchain

- macOS + Homebrew 환경에서, 여러 프로그래밍 언어의 컴파일러/런타임(Node.js, Java, Python, Rust, Go)을 asdf로 설치하고 셸 환경변수까지 잡아주는 개인용 부트스트랩 도구입니다.
- 목적: GitHub에서 한 줄 명령으로 받아서, 원하는 언어를 체크하듯 골라 컴파일러/빌드도구를 한 번에 깔고 환경변수 설정까지 끝내는 것.

#### 빠른 시작

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | bash
```

실행하면 언어별로 설치할지 물어보고(Enter = 예), 버전을 확인/수정할 수 있게 한 뒤, 마지막에 "설치할까요?"로 한 번 더 확인하고 나서 실제 설치를 시작합니다.

```
nodejs (node) 설치할까요? [Y/n] >
  버전 [기본값: lts] >
java (java) 설치할까요? [Y/n] >
...
== 설치 목록 ==
  nodejs  lts
  python  3.12.13
설치할까요? [Y/n] >
```

로컬에 이미 클론해뒀다면 그냥:

```zsh
./install.sh
```

**옵션**
| 플래그 | 동작 |
|---|---|
| `--all` | 언어 선택 화면 없이 `.tool-versions`에 있는 걸 전부 설치 |
| `--yes` | 마지막 "설치할까요?" 확인을 건너뜀 |
| `--dry-run` | 실제로 아무것도 바꾸지 않고, 뭘 할지만 출력 |

터미널(tty)이 없는 환경(CI 등)에서 실행하면 자동으로 `--all`처럼 동작합니다 — 입력을 기다리다 멈추지 않습니다.

#### 사전 요구사항

- macOS
- [Homebrew](https://brew.sh) — 없으면 설치기가 바로 에러를 내고 안내합니다.
- (원격 설치 시) `git` — macOS에 Xcode Command Line Tools가 있으면 기본 포함

asdf 자체는 설치기가 알아서 `brew install asdf`로 설치합니다.

#### 설치되는 것

`.tool-versions`에 정의된 기본 언어/버전 (설치 화면에서 개별적으로 켜고 끄거나 버전을 바꿀 수 있음):

| 언어 | 기본 버전 |
|---|---|
| Node.js | lts |
| Java (Temurin) | temurin-25.0.2+10.0.LTS |
| Python | 3.12.13 |
| Rust | 1.94.0 |
| Go | 1.26.1 |

Python 컴파일에 필요한 Homebrew 패키지(`openssl`, `readline`, `sqlite3`, `xz`, `zlib`, `tcl-tk`)도 함께 설치됩니다.

#### 설치 확인

```zsh
source ~/.zshrc   # 또는 새 터미널 탭
node -v && java -version && python --version && rustc --version && go version
which node java python rustc go   # ~/.asdf/shims/... 아래를 가리켜야 정상
```

#### 제거

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/uninstall.sh | bash
```

asdf, 설치된 런타임, 관련 Homebrew 패키지, 이 도구가 `.zshrc`/`.bash_profile`/`.bashrc`에 추가한 설정을 모두 제거합니다. 실행 전 한 번 확인을 물으며(`--yes`로 생략 가능), `--dry-run`도 동일하게 지원합니다. 제거 후에는 `exec $SHELL`로 새 셸 세션을 열어야 PATH 등 캐시된 상태가 완전히 사라집니다.

#### 코드 구조

```
install.sh              curl로 받는 진입점. 로컬 클론이면 바로 실행, 아니면 git clone 후 실행
uninstall.sh             위와 동일한 패턴의 제거용 진입점
.tool-versions           기본 언어/버전 목록 (asdf 포맷)
scripts/lib.sh           공용 유틸(로깅, dry-run, asdf PATH 보장 등) — 각 phase가 가져다 쓰는 모듈
scripts/install/         설치 단계, 역할별로 파일 분리 (00_select ~ 07_validate + main.sh)
scripts/uninstall/       제거 단계, 동일한 패턴 (01_uninstall_runtimes ~ 06_validate_teardown + main.sh)
```

`scripts/install`, `scripts/uninstall` 아래 각 파일은 서로 `source`하거나 순서에 의존하지 않고 독립적으로 실행 가능하도록 만들어져 있습니다(각자 asdf PATH를 스스로 보장). `main.sh`는 이 파일들을 순서대로 호출하는 오케스트레이터일 뿐입니다. 특정 단계만 고치거나 디버깅할 땐 `bash scripts/install/05_install_runtimes.sh`처럼 개별 실행해도 됩니다.

#### To-Do

- [ ] GitHub 레포 이름을 `langtoolchain`으로 맞추기 (현재 remote는 `amosQP/EasyEnv`)
- [ ] 실제 머신(클린 VM 등)에서 `--dry-run` 없이 전체 설치 1회 검증
- [ ] 언어 추가/제거 시 `.tool-versions`만 고치면 되는지 재확인
