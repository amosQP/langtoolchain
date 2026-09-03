---
id: decision-2
title: 'asdf 플러그인 소스 커밋 고정: 하지 않기로 결정'
date: '2026-09-03 01:19'
status: accepted
---
## Context

TASK-117.3(scripts/install/02_install_plugins.sh:55 — `asdf plugin add "$plugin"`)는 asdf
플러그인 저장소(asdf-nodejs, asdf-java/temurin, asdf-python, asdf-rust, asdf-golang)를
git commit 단위로 고정할 수 있는지 검토하는 태스크였다. 2026-09-03 asdf 0.20.0(Go 재작성,
이 저장소가 실제로 쓰는 버전) 소스코드를 직접 확인했다:

- `internal/cli/cli.go`의 `pluginAddCommand`는 `plugins.Add(conf, pluginName, pluginRepo, "")`를
  호출한다 — `ref` 인자가 **하드코딩된 빈 문자열**이다. CLI 사용법 문자열도
  `"asdf plugin add <name> [<git-url>]"`로 딱 두 개의 위치 인자만 받고, 커밋/태그를 지정할
  세 번째 인자는 아예 파싱되지 않는다.
- 내부적으로는 `plugins.Add()` 함수 시그니처에 `ref string` 파라미터가 실제로 존재하고
  (`plugin test`의 `--asdf-plugin-gitref` 플래그가 이걸 쓴다), `internal/git/git.go`의
  `Repo.Clone(pluginURL, ref)`도 `ref`가 있으면 `git clone --depth 1 <url> <dir> --branch <ref>`로
  분기하긴 한다 — 하지만 이 경로에 도달하는 건 `plugin test` 커맨드뿐이고, `plugin add`는
  절대 이 인자를 채우지 않는다. 즉 "내부 지원은 있지만 `plugin add`엔 노출되지 않음"이
  정확한 상태.
- 설령 `ref`를 직접 채워 넣을 수 있다 해도 `--branch <ref>`는 브랜치/태그 이름만 받고
  임의의 커밋 SHA는 안정적으로 받지 못한다(TASK-117.1에서 이미 확인한 것과 동일한 제약).
  게다가 clone 자체가 `--depth 1`(shallow)이라, add 시점 이후에 "그 커밋으로 되돌리기"
  같은 사후 조치도 매 플러그인마다 unshallow/특정 커밋 fetch가 추가로 필요해진다.
- `scripts/install/02_install_plugins.sh:25`는 매 install 실행마다 `asdf plugin update --all`을
  먼저 돌린다 — 이미 설치된 플러그인도 매번 각 저장소의 최신 default-branch HEAD로 갱신된다.
  즉 이 저장소가 마주한 floating-HEAD 노출은 "최초 add 시점"뿐 아니라 "재실행할 때마다"도
  해당한다.

## Decision

**지금 당장은 커밋 고정을 구현하지 않는다.** 대신 이 조사 결과를 결정으로 기록하고,
TASK-117.4(신뢰 경계 문서화)에서 이 지점을 "위임/통제 밖" 항목으로 명시한다.

근거:

1. **asdf CLI가 고정 메커니즘 자체를 제공하지 않는다** — `plugin add`에 ref를 넘길 방법이
   없으므로, 고정하려면 asdf의 plugin-add 로직을 이 저장소가 직접 재구현(자체 git clone +
   plugin 디렉토리 구조를 asdf가 기대하는 형태로 수동 배치)해야 한다. 이는 asdf 내부
   디렉토리 레이아웃/향후 버전 변경에 이 저장소가 종속되는 새로운 유지보수 부담을 만든다 —
   decision-1이 이미 "완전한 tamper-proof를 목표로 삼지 않는다"고 그은 경계와 같은 이유로
   비용 대비 이득이 낮다고 판단.
2. **5개 플러그인 각각의 pin을 손으로 갱신해야 하는 유지보수 부담** — TASK-117.1/117.2처럼
   이 저장소 자신의 커밋 하나, Homebrew 설치 스크립트 커밋 하나를 고정하는 것과 달리, 이건
   언어별로 서로 다른 속도로 갱신되는 5개의 외부 저장소를 계속 추적해야 하는 일이라 실질
   부담이 훨씬 크다.
3. **매 실행마다 `plugin update --all`이 이미 최신으로 갱신하는 구조라 "add 시점만" 고정해도
   실효성이 제한적** — 고정하려면 `plugin update --all` 호출 자체도 함께 바꿔야 해서 범위가
   더 커진다.
4. 이 지점의 실제 위협(악의적으로 변조된 플러그인 저장소 커밋을 받는 것)은 Homebrew bottle
   위임(TASK-116.2의 통제-밖 지점들)과 성격이 같다 — 이 저장소가 신뢰를 위임하고 있다는
   사실을 문서화하는 것이 여기서 실질적으로 할 수 있는 조치다.

## Consequences

- TASK-117.3은 "고정 구현"이 아니라 "검토 후 미고정 결정"으로 완료 처리한다.
- TASK-117.4(신뢰 경계 문서화)에 `scripts/install/02_install_plugins.sh:55`(asdf plugin add)
  를 "통제 밖(위임)" 항목으로 추가한다 — docs/download-points-inventory.md의 #5는 이미
  "검토 대상"으로 분류돼 있었으므로, 이 결정 이후 "통제 밖(문서화만)"으로 갱신한다.
- 향후 asdf가 `plugin add`에 ref 인자를 공식 노출하게 되면(현재 내부 함수 시그니처는 이미
  준비돼 있으므로 가능성은 있다) 이 결정을 재검토할 수 있다 — 그때는 CLI 인자 하나 추가하는
  수준의 비용으로 재평가가 가능해진다.
