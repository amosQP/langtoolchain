<div align="center">

# 🧰 langtoolchain

**macOS 한 줄 명령으로 Node.js · Java · Python · Rust · Go 컴파일러를 통째로 설치**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS-000000?logo=apple&logoColor=white)](#-사전-요구사항)
[![Shell](https://img.shields.io/badge/shell-POSIX%20sh-4EAA25)](#-설계-원칙)
[![Powered by asdf](https://img.shields.io/badge/powered%20by-asdf-F16436)](https://asdf-vm.com)

**한국어** | [English](readme.en.md)

`git clone`도, 수동 설치도 필요 없습니다. 터미널에 한 줄 붙여넣으면 끝.

</div>

<br>

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | sh
```

<br>

## 왜 만들었나

새 Mac을 받을 때마다 Homebrew 깔고, asdf 깔고, 언어별 플러그인 추가하고, 컴파일 플래그 맞춰서 `.zshrc` 고치고… 매번 똑같은 삽질을 반복하는 게 지겨워서 만들었습니다. **이제는 한 줄이면 됩니다.** Homebrew도 없으면 알아서 깔고, asdf도 알아서 깔고, 원하는 언어만 체크하듯 골라서 설치하고, 셸 설정까지 자동으로 끝납니다.

- 🍺 **Homebrew 없어도 OK** — 없으면 공식 스크립트로 자동 설치 (sudo 비밀번호만 직접 입력)
- ☑️ **체크박스 같은 대화형 설치** — 언어별로 설치 여부와 버전을 확인하고 골라서 설치
- 🌐 **`curl | sh` 완전 지원** — 로컬에 아무것도 없어도 원격 저장소를 알아서 clone해서 실행
- 🌍 **전역 or 디렉토리별 버전 고정** — 시스템 전체 기본값으로도, 특정 프로젝트에만도 자유롭게
- 🧩 **독립적인 모듈 구조** — 각 단계가 서로 의존하지 않아서, 필요한 부분만 골라 읽고 고치기 쉬움
- 🔙 **깔끔한 제거** — 설치한 건 전부 되돌릴 수 있음 (`.bak` 백업까지 남김)
- 🖥️ **POSIX sh 호환** — macOS 기본 셸(`/bin/sh`)에서도 그대로 동작, bash 특수문법 없음

<br>

## 📦 관리 범위

langtoolchain이 설치·관리하는 건 **Node.js·Java·Python·Rust·Go 5개 언어**와 그걸 위한 Homebrew 패키지
6개(`asdf`, `openssl` 등)뿐입니다. 그 외에 Mac에 이미 있거나 앞으로 `brew install`할 다른 패키지,
다른 언어의 asdf 플러그인, 다른 버전 관리자는 전혀 건드리지 않습니다.

| | langtoolchain이 관리 | 관리 안 함 |
|---|---|---|
| 🍺 Homebrew | `asdf` + 컴파일용 시스템 패키지 6개 | 그 외 모든 `brew` 패키지 |
| 🧬 asdf | `nodejs`/`java`/`python`/`rust`/`golang` 플러그인 | 다른 언어·도구용 플러그인 |
| 🗂️ 버전 고정 | 고른 언어를, 고른 범위(전역/디렉토리)에만 | 나머지 프로젝트·설정 |

<br>

## 목차

- [빠른 시작](#-빠른-시작)
- [관리 범위](#-관리-범위)
- [사전 요구사항](#-사전-요구사항)
- [설치되는 것](#-설치되는-것)
- [어떻게 동작하는가](#%EF%B8%8F-어떻게-동작하는가)
- [버전 고정 범위: 전역 vs 디렉토리별](#-버전-고정-범위-전역-vs-디렉토리별)
- [파일시스템 명세](#-설치하면-어디에-뭐가-생기는가-파일시스템-명세)
- [설치 확인 / 제거](#-설치-확인)
- [코드 구조](#-코드-구조-파일별-설명)
- [설계 원칙](#-설계-원칙)
- [기여하기](#-기여하기)
- [License](#-license)

<br>

## 🚀 빠른 시작

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | sh
```

로컬에 이미 클론해뒀다면:

```zsh
git clone https://github.com/amosQP/langtoolchain.git && cd langtoolchain
./install.sh
```

실행하면 언어별로 설치할지 물어보고(Enter = 예), 버전을 확인/수정할 수 있게 한 뒤, 마지막에 "설치할까요?"로 한 번 더 확인하고 나서 실제 설치를 시작합니다.

```text
== 설치할 언어를 선택하세요 (Enter = 예) ==

nodejs (node) 설치할까요? [Y/n] > ⏎
  버전 [기본값: lts] > ⏎

java (java) 설치할까요? [Y/n] > n

python (python) 설치할까요? [Y/n] > ⏎
  버전 [기본값: 3.12.13] > ⏎
...
== 설치 목록 ==
  nodejs  lts
  python  3.12.13
  rust    1.94.0
  golang  1.26.1

전역으로 고정할까요, 이 디렉토리에만 고정할까요? [전역/로컬, 기본값: 전역] > ⏎

설치할까요? [Y/n] > ⏎
```

> 마지막 프롬프트는 이번에 설치한 버전을 **어디에** 활성화할지 고릅니다 — 자세한 내용은
> 바로 아래 [버전 고정 범위](#-버전-고정-범위-전역-vs-디렉토리별) 참고.

<details>
<summary><b>옵션 플래그</b> (<code>curl | sh -s -- &lt;옵션&gt;</code> 형태로 전달 가능)</summary>
<br>

| 플래그 | 대상 | 동작 |
|---|---|---|
| `--all` | install | 언어 선택 화면 없이 `.tool-versions`에 있는 걸 전부 설치 |
| `--yes` | install / uninstall | 마지막 확인 프롬프트를 건너뜀 |
| `--dry-run` | install / uninstall | 실제로 아무것도 바꾸지 않고, 뭘 할지만 출력 |
| `--local` / `--local=<dir>` | install | 전역 대신 현재(또는 지정한) 디렉토리에만 버전 고정. [자세히 보기](#-버전-고정-범위-전역-vs-디렉토리별) |

> 터미널(tty)이 없는 환경(CI 등)에서 실행하면 자동으로 `--all`처럼 동작합니다 — 입력을 기다리다 멈추지 않습니다.

</details>

<br>

## 📋 사전 요구사항

| 필요한 것 | 없으면? |
|---|---|
| macOS | 이 도구는 macOS 전용입니다 |
| `git` (원격 설치 시) | Xcode Command Line Tools에 기본 포함 |
| ~~Homebrew~~ | 없으면 설치기가 알아서 설치합니다 (sudo 비밀번호는 직접 입력 필요) |
| ~~asdf~~ | 없으면 `brew install asdf`로 알아서 설치합니다 |

<br>

## 📦 설치되는 것

`.tool-versions`에 정의된 기본 언어/버전 — 설치 화면에서 개별적으로 켜고 끄거나 버전을 바꿀 수 있습니다.

| 언어 | 기본 버전 |
|---|---|
| 🟩 Node.js | `lts` |
| ☕ Java (Temurin) | `temurin-25.0.2+10.0.LTS` |
| 🐍 Python | `3.12.13` |
| 🦀 Rust | `1.94.0` |
| 🐹 Go | `1.26.1` |

Python 컴파일에 필요한 Homebrew 패키지(`openssl`, `readline`, `sqlite3`, `xz`, `zlib`, `tcl-tk`)도 함께 설치됩니다.

<br>

## ⚙️ 어떻게 동작하는가

```mermaid
flowchart TD
    A["install.sh<br/>(진입점)"] --> B["00_select.sh<br/>언어/버전 선택"]
    B --> C["01_bootstrap_asdf.sh<br/>Homebrew + asdf"]
    C --> D["02_install_plugins.sh<br/>asdf plugin add"]
    D --> E["03_install_system_deps.sh<br/>Python 빌드 의존성"]
    E --> F["04_configure_shell_env.sh<br/>.zshrc / .bash_profile"]
    F --> G["05_install_runtimes.sh<br/>asdf install (컴파일/다운로드)"]
    G --> H["06_set_globals.sh<br/>asdf set (전역/로컬) + reshim"]
    H --> I["07_validate.sh<br/>설치 검증"]
```

1. **진입점 (`install.sh`)** — 로컬에 클론된 상태로 실행됐으면(`scripts/install/` 디렉토리가 옆에 있으면) 바로 그걸 실행합니다. `curl | sh`로 stdin을 통해 실행된 경우엔(로컬에 아무 파일도 없는 경우) `git clone --depth 1`로 임시 디렉토리(`mktemp -d`)에 저장소를 내려받은 뒤 그 안의 스크립트를 실행하고, 끝나면 `trap`으로 임시 디렉토리를 지웁니다.
2. **언어 선택 (`00_select.sh`)** — 언어별로 설치 여부(Y/n)와 버전, 그리고 이걸 전역으로 고정할지 특정 디렉토리에만 고정할지를 물어봅니다. 모든 프롬프트/출력은 `/dev/tty`에 직접 쓰고 읽어서, `curl | sh`처럼 표준입력이 이미 스크립트 내용으로 막혀 있어도 정상적으로 사용자 입력을 받습니다. 결과는 `.tool-versions` 형식의 임시 파일로 저장되고, 그 파일 경로만 표준출력으로 반환됩니다. 터미널이 없으면(CI 등) 자동으로 전체 설치로 폴백하고, 고정 범위도 `--local`이 없으면 전역으로 기본 설정됩니다.
3. **Homebrew/asdf 부트스트랩 (`01_bootstrap_asdf.sh`)** — Homebrew가 없으면 공식 설치 스크립트를 `NONINTERACTIVE=1`로 실행해 직접 설치합니다(sudo 비밀번호 입력은 그대로 필요). `asdf`가 없으면 `brew install asdf`로 설치합니다.
4. **플러그인 설치 (`02_install_plugins.sh`)** — 선택된 언어마다 `asdf plugin add`.
5. **시스템 의존성 (`03_install_system_deps.sh`)** — Python 컴파일에 필요한 Homebrew 패키지 설치.
6. **셸 환경변수 (`04_configure_shell_env.sh`)** — `~/.zshrc` 또는 `~/.bash_profile`(사용자의 로그인 셸에 따라 자동 판단)에 asdf shim PATH, Java 홈, 컴파일러 플래그를 멱등적으로(중복 없이) 추가합니다.
7. **런타임 설치 (`05_install_runtimes.sh`)** — `asdf install <plugin> <version>` — 실제로 시간이 오래 걸리는 컴파일/다운로드 단계.
8. **버전 고정 (`06_set_globals.sh`)** — 2번에서 정한 범위에 따라 `asdf set -u`(전역) 또는 `asdf set`(지정 디렉토리)을 실행하고 `asdf reshim`으로 shim을 재생성.
9. **검증 (`07_validate.sh`)** — 각 언어의 바이너리가 PATH에서 실제로 asdf shim을 통해 잡히는지, 버전이 올바른지 확인.

> **핵심 설계 원칙**: 각 단계는 `main.sh`가 별도의 `sh` 프로세스로 순서대로 실행합니다. **어느 한 단계도 다른 단계가 먼저 실행되어 뭔가를 `export`해뒀을 거라고 가정하지 않습니다.** 예를 들어 5번(런타임 설치)은 4번이 `.zshrc`에 PATH를 써놨다고 믿는 대신, 스스로 `ensure_asdf_on_path`/`ensure_build_flags`를 호출해 필요한 환경을 그 자리에서 만듭니다. 그래서 특정 단계 하나만 따로 실행해도(`sh scripts/install/05_install_runtimes.sh`) 정상 동작합니다.

<br>

## 🌍 버전 고정 범위: 전역 vs 디렉토리별

asdf는 언어 런타임을 **한 번만 설치**하고(`~/.asdf/installs/<plugin>/<version>/`), `.tool-versions`
파일로 "지금 어떤 설치된 버전을 쓸지"만 결정합니다. 이 고정에는 두 가지 범위가 있습니다.

| 범위 | 저장 위치 | 실행되는 명령 | 적용 범위 |
|---|---|---|---|
| **전역 (Global)** | `~/.tool-versions` | `asdf set -u <plugin> <version>` | 딱히 지정 안 된 모든 디렉토리의 기본값 |
| **디렉토리별 (Local)** | `<지정 디렉토리>/.tool-versions` | `asdf set <plugin> <version>` (`-u` 없음) | 그 디렉토리(와 하위 디렉토리) 안에서만, 전역값보다 우선 |

예: 평소엔 최신 Node.js를 쓰다가, 레거시 프로젝트 하나만 Node 18을 써야 할 때 그 프로젝트 디렉토리에만
로컬로 고정하면 다른 곳엔 영향 없이 그 프로젝트에서만 Node 18이 적용됩니다.

> 💡 **비유로 설명하면**: nvm의 `.nvmrc`, pyenv의 `.python-version` 같은 "이 폴더는 이 버전 써" 파일을
> asdf는 언어 상관없이 전부 `.tool-versions` 하나로 통일한 것뿐입니다. 전역은 그게 없을 때의 기본값.

### 사용법

**대화형**: 설치 마지막 확인 직전에 물어봅니다 (Enter = 전역).
```text
전역으로 고정할까요, 이 디렉토리에만 고정할까요? [전역/로컬, 기본값: 전역] > 로컬
  어느 디렉토리에 고정할까요? [기본값: 현재 디렉토리] > ⏎
```

**플래그** (비대화형, 프롬프트를 건너뜀):
```zsh
./install.sh --local                    # 현재 디렉토리에 고정
./install.sh --local=/path/to/project    # 지정한 디렉토리에 고정
./install.sh                             # (기본값) 전역에 고정
```

### 구현 방식

새 phase 스크립트를 추가하지 않고 기존 구조를 그대로 재사용합니다. `00_select.sh`가 언어 선택과 함께
고정 범위도 물어본 뒤, 선택 결과 파일의 **첫 줄에 주석으로 기록**합니다:

```
# scope: global
nodejs lts
python 3.12.13
```
또는
```
# scope: local /Users/me/myproject
nodejs lts
```

`each_tool`의 파싱 패턴(`#`으로 시작하는 줄은 무시)이 이 줄을 자동으로 건너뛰므로 언어/버전 파싱 로직은
전혀 안 바뀝니다. `06_set_globals.sh`가 `read_scope()`(`scripts/lib.sh`)로 이 줄을 읽어 분기합니다 —
줄이 아예 없으면(예: 이 저장소의 `.tool-versions`를 직접 쓰는 경우) 항상 전역으로 동작해 기존 동작과
100% 호환됩니다.

### 이미 로컬로 고정된 걸 나중에 직접 다루고 싶다면

langtoolchain은 이 표준 asdf 명령을 대신 실행해주는 것뿐입니다 — 그 디렉토리의 `.tool-versions`를
직접 열어보거나, `asdf current`로 확인하거나, 직접 `asdf set <plugin> <version>`을 실행해도 됩니다.
별도로 배워야 할 langtoolchain 전용 명령은 없습니다.

<br>

## 🗂️ 설치하면 어디에 뭐가 생기는가 (파일시스템 명세)

### 언어별 실제 설치 위치

전부 asdf가 관리하며, 아래 두 경로 규칙을 따릅니다.

| 언어 | plugin 이름 | 설치 디렉토리 (`asdf install`) | shim (PATH가 실제로 가리키는 것) |
|---|---|---|---|
| 🟩 Node.js | `nodejs` | `~/.asdf/installs/nodejs/<version>/` | `~/.asdf/shims/node`, `npm`, `npx` 등 |
| ☕ Java | `java` | `~/.asdf/installs/java/<version>/` | `~/.asdf/shims/java`, `javac` 등 |
| 🐍 Python | `python` | `~/.asdf/installs/python/<version>/` | `~/.asdf/shims/python`, `pip` 등 |
| 🦀 Rust | `rust` | `~/.asdf/installs/rust/<version>/` | `~/.asdf/shims/rustc`, `cargo` 등 |
| 🐹 Go | `golang` | `~/.asdf/installs/golang/<version>/` | `~/.asdf/shims/go`, `gofmt` 등 |

> `<version>`은 `.tool-versions`에 적힌 그대로의 문자열입니다 — 예를 들어 `nodejs`는 실제로 `~/.asdf/installs/nodejs/lts/`처럼 `lts`라는 이름의 디렉토리가 그대로 생깁니다. 각 언어 플러그인 자체의 소스는 `~/.asdf/plugins/<plugin>/`에 따로 있습니다.

### 공용 asdf 상태 (`$ASDF_DATA_DIR`, 기본값 `~/.asdf/`)

| 경로 | 내용 |
|---|---|
| `~/.asdf/plugins/` | 각 언어 플러그인의 git 체크아웃 |
| `~/.asdf/installs/` | 실제 컴파일된 런타임들 (위 표) |
| `~/.asdf/downloads/` | 설치 중 받은 소스/바이너리 캐시 |
| `~/.asdf/shims/` | PATH가 실제로 가리키는 얇은 래퍼 실행파일들 |

### 설정이 저장되는 곳

| 파일 | 무엇이 들어가는가 | 어느 스크립트가 쓰는가 |
|---|---|---|
| `~/.tool-versions` (전역 — 이 저장소의 `.tool-versions`와는 다른 파일) | 언어별 전역 기본 버전 | `06_set_globals.sh`의 `asdf set -u` (기본, 또는 `--local` 없이 실행 시) |
| `<지정 디렉토리>/.tool-versions` (`--local` 사용 시에만) | 그 디렉토리 안에서만 적용되는 버전 | `06_set_globals.sh`의 `asdf set` — [버전 고정 범위](#-버전-고정-범위-전역-vs-디렉토리별) 참고 |
| `~/.zshrc` 또는 `~/.bash_profile` (로그인 셸에 따라 자동 선택) | `eval "$(brew shellenv)"`(파일 맨 위에 prepend), `ASDF_DATA_DIR`/PATH shim export, Java 홈 훅, `LDFLAGS`/`CPPFLAGS`/`PKG_CONFIG_PATH` | `04_configure_shell_env.sh` |
| 이 저장소의 `.tool-versions` | **읽기 전용** — 언어/기본 버전 목록의 소스. 설치기가 여기에 쓰지 않음 | 모든 phase 스크립트가 읽기만 함 |

### Homebrew로 설치되는 것 (`/opt/homebrew/` 아래, Apple Silicon 기준)

`asdf` · `openssl` · `readline` · `sqlite3` · `xz` · `zlib` · `tcl-tk`

### 임시로만 쓰이는 것

- **언어 선택 결과 파일**: `mktemp -t langtoolchain-selection`으로 시스템 임시 디렉토리(`$TMPDIR`)에 생성, 설치 완료 후 `main.sh`가 삭제
- **`curl | sh` 실행 시의 저장소 클론**: `mktemp -d`로 임시 디렉토리에 clone, 스크립트 종료 시 `trap`으로 자동 삭제

### 제거 시 지워지는 것 (`uninstall.sh`)

`~/.asdf/` 전체(위 표의 모든 내용) · Homebrew로 설치된 `asdf`/`openssl`/`readline`/`sqlite3`/`xz`/`zlib`/`tcl-tk` · `~/.tool-versions`(전역) · `~/.zshrc`/`~/.bash_profile`/`~/.bashrc`에 추가됐던 줄들(`sed -i '.bak'`로 지우며 백업은 `<파일>.bak`로 남김).

> ⚠️ **이 저장소 자신의 `.tool-versions`는 절대 건드리지 않습니다.**

<br>

## ✅ 설치 확인

```zsh
source ~/.zshrc   # 또는 새 터미널 탭
node -v && java -version && python --version && rustc --version && go version
which node java python rustc go   # ~/.asdf/shims/... 아래를 가리켜야 정상
```

<br>

## 🗑️ 제거

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/uninstall.sh | sh
```

실행 전 한 번 확인을 물으며(`--yes`로 생략 가능), `--dry-run`도 동일하게 지원합니다. 제거 후에는 `exec $SHELL`로 새 셸 세션을 열어야 PATH 등 캐시된 상태가 완전히 사라집니다.

<br>

## 📁 코드 구조 (파일별 설명)

```
langtoolchain/
├── install.sh              ⇐ curl 진입점
├── uninstall.sh             ⇐ curl 진입점 (제거용)
├── .tool-versions            기본 언어/버전 목록 (읽기 전용 소스)
├── LICENSE                   MIT
└── scripts/
    ├── lib.sh                공용 유틸리티 모듈
    ├── install/               설치 단계 (역할별 파일 분리)
    │   ├── 00_select.sh
    │   ├── 01_bootstrap_asdf.sh
    │   ├── 02_install_plugins.sh
    │   ├── 03_install_system_deps.sh
    │   ├── 04_configure_shell_env.sh
    │   ├── 05_install_runtimes.sh
    │   ├── 06_set_globals.sh
    │   ├── 07_validate.sh
    │   └── main.sh
    └── uninstall/             제거 단계 (동일한 패턴)
        ├── 01_uninstall_runtimes.sh
        ├── 02_remove_plugins.sh
        ├── 03_clean_env_vars.sh
        ├── 04_remove_system_deps.sh
        ├── 05_purge_asdf_core.sh
        ├── 06_validate_teardown.sh
        └── main.sh
```

### 루트

| 파일 | 역할 |
|---|---|
| `install.sh` | curl 진입점. 로컬 클론이면 `scripts/install/main.sh`를 바로 실행, 아니면 `git clone`으로 임시 디렉토리에 받아서 실행 |
| `uninstall.sh` | 위와 동일한 패턴의 제거용 진입점 (`scripts/uninstall/main.sh` 호출) |
| `.tool-versions` | 기본으로 설치할 언어/버전 목록. asdf의 표준 포맷(`플러그인 버전`)을 그대로 씀 — 언어를 추가/변경하려면 이 파일 한 줄만 고치면 됨 |

### `scripts/lib.sh`

모든 phase 스크립트가 공유하는 순수 함수 모음. 이 파일 하나를 소스(source)하는 것 외에는 phase 스크립트끼리 서로 의존하지 않습니다.

| 함수 | 역할 |
|---|---|
| `log`, `step`, `die` | 로그 출력, 섹션 헤더 출력, 에러 후 즉시 종료 |
| `run` | `--dry-run`이면 명령을 출력만 하고, 아니면 실제로 실행 |
| `repo_root_from` | 스크립트 자기 자신의 경로로부터 저장소 루트를 역산 |
| `each_tool` | `.tool-versions` 형식 파일을 `플러그인 버전` 쌍으로 파싱 |
| `detect_rc_file` | `$SHELL` 기준으로 `.zshrc`/`.bash_profile` 중 무엇을 고칠지 결정 |
| `append_env_var` | rc 파일 맨 **끝**에 줄을 멱등적으로(중복 없이) 추가 |
| `prepend_env_var` | rc 파일 맨 **앞**에 줄을 멱등적으로 추가 — PATH 우선순위가 중요한 줄(`brew shellenv`)에 사용 |
| `read_scope` | 선택 파일의 `# scope: ...` 줄을 읽어 "global" 또는 "local:\<dir\>"을 반환 (줄이 없으면 "global") |
| `ensure_asdf_on_path` | 이 프로세스에서 asdf/shim이 PATH에 잡히도록 보장 |
| `ensure_brew_on_path` | 이 프로세스에서 `brew`가 PATH에 잡히도록 보장 (Apple Silicon/Intel 설치 경로 자동 판단) |
| `ensure_build_flags` | Python 등 컴파일에 필요한 `LDFLAGS`/`CPPFLAGS`/`PKG_CONFIG_PATH`를 이 프로세스에 export |
| `binary_for_plugin`, `flag_for_binary` | plugin 이름 ↔ 실제 실행파일 이름 ↔ 버전 확인 플래그 매핑 (POSIX sh엔 연관 배열이 없어서 `case`로 구현) |
| `version_core` | 버전 문자열에서 `X.Y[.Z]` 숫자 부분만 추출 (예: `temurin-25.0.2+10.0.LTS` → `25.0.2`), `lts`처럼 숫자가 없으면 실패 반환 |
| `lt_homebrew_prefix` | 현재 CPU 아키텍처의 Homebrew 설치 경로 반환 (`/opt/homebrew` 또는 `/usr/local`) |
| `lt_env_var_defs` | rc 파일에 쓰는 모든 줄의 검색 패턴/삽입 위치/내용을 한 곳에서 정의 — install과 uninstall이 이 정의 하나를 공유해서 서로 어긋나지 않게 함 |

### `scripts/install/`

| 파일 | 역할 |
|---|---|
| `00_select.sh` | 언어별 설치 여부/버전, 그리고 버전 고정 범위(전역/로컬)를 물어보는 대화형 선택기. `/dev/tty`로 직접 읽고 써서 `curl \| sh`에서도 동작. 결과를 임시 `.tool-versions` 파일(첫 줄에 `# scope: ...` 포함)로 반환 |
| `01_bootstrap_asdf.sh` | Homebrew 없으면 공식 스크립트로 설치(sudo 필요), `asdf` 없으면 `brew install asdf` |
| `02_install_plugins.sh` | 선택된 언어마다 `asdf plugin add` |
| `03_install_system_deps.sh` | Python 컴파일용 Homebrew 패키지 설치 |
| `04_configure_shell_env.sh` | rc 파일에 asdf/빌드 환경변수 기록 |
| `05_install_runtimes.sh` | `asdf install` — 실제 컴파일/다운로드 |
| `06_set_globals.sh` | 선택 파일의 `# scope:` 줄에 따라 `asdf set -u`(전역) 또는 `asdf set`(로컬) 실행 + `asdf reshim` |
| `07_validate.sh` | 설치 결과 검증 (바이너리 경로, 버전 출력) |
| `main.sh` | 위 스크립트들을 순서대로 실행하는 오케스트레이터. `--dry-run`/`--all`/`--yes`/`--local[=DIR]` 플래그를 처리해 필요한 것만 `00_select.sh`로 전달 |

### `scripts/uninstall/`

설치의 역순, 동일한 독립 실행 원칙.

| 파일 | 역할 |
|---|---|
| `01_uninstall_runtimes.sh` | `asdf uninstall`로 설치된 런타임 제거 |
| `02_remove_plugins.sh` | 설치된 모든 asdf 플러그인 제거 |
| `03_clean_env_vars.sh` | rc 파일들에서 이 도구가 추가한 줄 제거 (`.bak` 백업 남김) |
| `04_remove_system_deps.sh` | Homebrew 시스템 패키지 제거 |
| `05_purge_asdf_core.sh` | `asdf` 자체와 `~/.asdf/`, 전역 `~/.tool-versions` 제거 |
| `06_validate_teardown.sh` | 제거 결과 검증 |
| `main.sh` | 위를 순서대로 실행 + 실행 전 확인 프롬프트 |

<br>

## 🧠 설계 원칙

기여하기 전에 알아두면 좋은 것들입니다.

<details>
<summary><b>1. 각 phase는 서로 독립적입니다 — export에 의존하지 않음</b></summary>
<br>

각 phase 스크립트는 `main.sh`가 별도의 `sh` 프로세스로 실행합니다. 즉 한 phase에서 `export`한 값은 다음 phase로 자동으로 넘어가지 않습니다. 그래서 `asdf`나 빌드 플래그가 필요한 스크립트는 각자 `ensure_asdf_on_path`/`ensure_build_flags`를 직접 호출합니다. 이 원칙 덕분에 아무 phase나 단독으로(`sh scripts/install/05_install_runtimes.sh`) 실행해도 정상 동작하고, 순서를 바꾸거나 phase를 추가/삭제하기도 쉽습니다.
</details>

<details>
<summary><b>2. .tool-versions를 읽는 루프는 표준입력이 아니라 fd 3을 씁니다</b></summary>
<br>

`.tool-versions`를 파싱해서 `while read ...; do ... done` 루프를 도는 코드는 항상 파일디스크립터 3번을 씁니다. 루프 안에서 `asdf` 같은 외부 명령을 또 실행하기 때문인데, 표준입력을 그대로 쓰면 그 명령이 실수로 루프용 입력을 가로챌 수 있어서입니다. POSIX sh엔 프로세스 치환(`<(cmd)`)이 없으므로, `each_tool "$CONFIG_FILE" > "$TMP"`로 먼저 임시 파일에 담은 뒤 `done 3< "$TMP"`로 그 파일을 fd 3에 연결하는 두 단계로 이뤄집니다 — 원칙 4의 POSIX 호환 정책과 같은 이유입니다.
</details>

<details>
<summary><b>3. 파이프를 곧장 grep -q로 넘기지 않습니다 (SIGPIPE)</b></summary>
<br>

`asdf plugin list | grep -q ...`처럼 "명령 출력을 곧장 `grep -q`로 파이프"하는 패턴은 위험합니다 — `grep -q`가 매치되자마자 파이프를 일찍 닫아버리는데, 그 타이밍에 상류 명령이 아직 출력 중이면 SIGPIPE로 죽습니다. (예전엔 `set -o pipefail`과 함께 쓸 때만의 문제로 설명했지만, `pipefail`은 bash/ksh/zsh 전용 확장이라 POSIX sh 전환 이후로는 애초에 쓰지 않습니다 — SIGPIPE로 상류 명령이 죽는 것 자체는 pipefail 유무와 무관한 문제라 이 원칙은 그대로 유지됩니다.) 명령 출력은 변수에 먼저 담고, 그 변수를 grep하세요.
</details>

<details>
<summary><b>4. POSIX sh 호환을 유지합니다</b></summary>
<br>

기본 포맷(들여쓰기, 라인 길이, 네이밍)은 [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)를 따르되, 호환성 레이어는 POSIX sh입니다 — bash 전용 문법을 쓰지 않아서, `curl | sh`로 실행될 때 PATH에 어떤 `sh`가 잡히든(dash, ash, posix 모드 bash 등) 그대로 동작합니다. 구체적으로 이런 걸 안 씁니다:

- `[[ ... ]]` 대신 `[ ... ]`, 글롭 패턴 매칭이 필요한 곳은 `case`문
- 연관 배열(`declare -A`)이나 인덱스 배열(`arr=()`, `arr+=()`) — 대신 개행으로 구분한 문자열 + `IFS`/`set --`로 위치 매개변수를 재구성 (값에 공백이 있어도 안전, 개행에서만 분리)
- 프로세스 치환 `<(cmd)` — 대신 `mktemp`로 임시 파일을 만들어 그걸 읽음
- `[[ =~ ]]`/`BASH_REMATCH` 정규식 매칭 — 대신 `sed`의 BRE(basic regular expression)로 대체
- `set -o pipefail` — POSIX에 없는 bash/ksh/zsh 전용 옵션
- `&>` 결합 리다이렉트 — 대신 `>file 2>&1`
- `${BASH_SOURCE[0]}` — 대신 `$0` (모든 스크립트가 항상 경로로 호출되므로 안전)

한 가지 함정: `:`(콜론, no-op)처럼 POSIX가 "특수 내장명령(special built-in)"으로 규정한 명령은, 리다이렉션이 실패하면 `set -e`나 `||`와 무관하게 비대화형 셸을 무조건 즉시 종료시킵니다(POSIX 표준 동작이며 dash가 정확히 이렇게 구현되어 있음 — bash는 기본 모드에서 더 관대해서 이 문제가 안 보였습니다). `/dev/tty` 존재 여부를 확인하는 코드처럼 "실패할 수도 있는 리다이렉션 + `||` 폴백" 패턴에선 `:` 대신 `true`(특수 내장명령이 아님) 같은 평범한 명령을 씁니다.
</details>

<details>
<summary><b>5. rc 파일에 PATH 줄을 추가할 땐 순서가 실제로 우선순위를 결정합니다</b></summary>
<br>

셸이 파일을 위에서부터 소싱하면서 매번 `export PATH="X:$PATH"`로 앞에 붙이기 때문에, **더 나중에 소싱되는 줄이 PATH 우선순위가 더 높습니다.** `brew shellenv`처럼 "제일 먼저 소싱되어야 하는" 줄은 `append_env_var`(파일 끝에 추가)가 아니라 `prepend_env_var`(파일 맨 앞에 추가)로 넣어야, 그 뒤에 오는 asdf shim PATH 줄이 항상 마지막에 prepend되어 우선순위를 가져갑니다.
</details>

<details>
<summary><b>6. 정리용 EXIT trap이 있는 스크립트에서는 exec를 쓰지 않습니다</b></summary>
<br>

`exec cmd`는 `execve`로 현재 프로세스 이미지를 통째로 교체합니다 — 셸의 정상 종료 절차(등록해둔 `trap ... EXIT` 포함)를 그대로 건너뜁니다. `install.sh`/`uninstall.sh`가 `curl | sh`로 실행될 때 임시 clone을 지우는 `trap 'rm -rf "$WORKDIR"' EXIT`가 있는 이유가 이겁니다 — 그 뒤에서 진짜 설치 스크립트를 실행할 땐 `exec`가 아니라 일반 호출 + `exit $?`를 씁니다. (반대로 로컬 클론 실행 경로처럼 정리할 게 없는 곳에선 `exec`를 그대로 씁니다 — 불필요한 프로세스 하나를 아낄 수 있어서.)
</details>

<details>
<summary><b>7. sed 스크립트는 macOS 기본 sed(BSD sed) 기준으로 씁니다</b></summary>
<br>

macOS의 `/usr/bin/sed`는 BSD sed로, GNU sed와 정규식 문법이 다릅니다. 특히 `\(a\|b\)` 같은 대체(alternation) 문법은 GNU sed 확장이라 BSD sed의 기본 모드(POSIX BRE)에서는 **조용히 아무것도 매칭하지 않습니다** — 에러도 안 나고 그냥 무시됩니다. 대체 문법이 필요하면 `-E`(확장 정규식) 플래그를 켜고 `\(`/`\)`/`\|` 대신 그냥 `(`/`)`/`|`를 쓰세요.
</details>

<br>

## 🤝 기여하기

- 언어/버전을 바꾸려면 `.tool-versions` 한 줄만 수정하면 됩니다.
- 특정 단계만 고치거나 디버깅할 땐 개별 실행: `DRY_RUN=true sh scripts/install/05_install_runtimes.sh`
- 코드를 고쳤으면 순서대로: `shellcheck -s sh <고친 파일>` → `dash -n <고친 파일>` (macOS 기본 `/bin/sh`는 posix 모드 bash라 진짜 POSIX 위반을 놓치므로, 실제 POSIX 셸인 dash로 다시 검사) → `shellspec` 그리고 `shellspec --shell dash`로 회귀 테스트 스위트(`spec/`) 실행.
- 실제로 아무것도 바꾸지 않고 전체 흐름 확인: `./install.sh --dry-run --all --yes`, `./uninstall.sh --dry-run --yes`
- 실기기 검증이 필요한 시나리오(클린 Homebrew 부트스트랩, Intel Mac 등)는 `.github/workflows/e2e-verify.yml`을 `workflow_dispatch`로 실행 — GitHub 호스팅 macOS 러너(arm64+Intel)에서 진짜 설치/제거 사이클을 돌립니다. 공개 저장소라 러너 사용은 무료입니다.

**남은 To-Do**
- [x] 실기기에서 `--dry-run` 없이 실제 설치 검증 (새 Node 버전을 실제로 설치/제거하며 phase 1~5, 7 검증)
- [x] 진짜 클린 Homebrew 자동 설치 경로까지 포함해 처음부터 전체 검증 — `e2e-verify.yml`의 `no-homebrew-bootstrap` 잡으로 CI에서 검증
- [x] Intel Mac(`/usr/local` 접두사) 경로 처리 확인 — `e2e-verify.yml`이 `macos-15-intel` 러너에서 설치/제거 전체 사이클을 실제로 검증

<br>

## 📝 License

<div align="center">

[MIT](https://opensource.org/licenses/MIT) — 누구나 자유롭게 가져다 쓰고 고칠 수 있습니다. (이 저장소의 [LICENSE](LICENSE) 파일도 동일한 내용입니다.)

Made with 🧉 by [amosQP](https://github.com/amosQP)

</div>
