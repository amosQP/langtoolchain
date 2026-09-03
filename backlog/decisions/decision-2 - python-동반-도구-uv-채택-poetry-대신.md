---
id: decision-2
title: 'python 동반 도구: uv 채택 (poetry 대신)'
date: '2026-09-03 01:24'
status: accepted
---
## Context

외부 리뷰(2026-08-30)에서 지적된 갭: `lt_companion_for_plugin()`(scripts/lib.sh)은
nodejs→pnpm, java→gradle만 지원하고 python의 핵심 패키지 관리자(uv/poetry)는
검토조차 안 돼 있었다(TASK-121). rust/golang은 표준 도구(cargo/go modules)가
언어 자체에 내장돼 있어 별도 companion이 필요 없다고 이미 판단됨 - python만
실제 갭.

판단 기준(TASK-121.1 AC): asdf 플러그인 존재/성숙도, 설치 방식(이 저장소는 이미
asdf 플러그인 체계로 모든 언어/동반도구를 설치하므로, "asdf 플러그인이 잘
동작하는가"가 곧 "이 저장소에 잘 맞는가"와 거의 동일), 최근 생태계 채택 추세.

2026-09-03 실측(GitHub API):
- uv 본체(astral-sh/uv): star 89,372, 오늘(2026-09-03) 기준 최근 push - 매우
  활발. pip/pip-tools/pipx/virtualenv/일부 poetry 워크플로를 단일 Rust 바이너리로
  대체하는 것을 목표로 하며, 2025-2026 사이 python 생태계에서 사실상 새 기본값으로
  빠르게 자리잡는 추세(Django 등 주요 프로젝트 문서에서도 권장 예시로 채택).
- poetry 본체(python-poetry/poetry): star 34,295, 2026-08-31 push - 여전히
  활발히 유지보수되고 있어 "죽은 프로젝트"는 아님.
- asdf-uv 플러그인(asdf-community/asdf-uv): 2026-08-28 push, `asdf plugin add uv`
  로 정상 추가/`asdf latest uv` 정상 동작 실측 확인(asdf-uv 플러그인, 이 개발
  머신에서 추가 후 제거까지 실제 실행해 검증, 종료 후 원상복구함).
- asdf-poetry 플러그인(asdf-community/asdf-poetry): 2026-06-19 push, 마찬가지로
  asdf-community 조직 소속의 유지되는 플러그인.
- 설치 방식: uv는 단일 정적 바이너리 배포(Rust) - asdf 플러그인이 GitHub
  릴리스에서 바이너리를 직접 받아오는 구조와 자연스럽게 맞음. poetry는 전통적으로
  pip/pipx 경유 설치가 흔하고, asdf-poetry 플러그인도 내부적으로 별도 python
  인터프리터를 거쳐 pip install을 수행하는 방식이라 - 이 저장소가 이미 만든
  "각 언어를 asdf 플러그인 하나로 곧장 설치"라는 일관된 모델과는 uv 쪽이 더
  깔끔하게 맞아떨어짐.

## Decision

**python의 동반 도구로 `uv`를 채택한다. `poetry`는 채택하지 않는다(둘 다 지원하는
방안도 고려했으나 기각).**

이유:
1. asdf 플러그인 성숙도: 두 플러그인 모두 asdf-community 소속으로 정상 동작함이
   실측 확인됐다 - 이 기준만으로는 우열이 크지 않다.
2. 설치 방식이 이 저장소의 기존 모델과 더 잘 맞는 쪽은 uv다 - 단일 바이너리
   배포라 asdf 플러그인의 "GitHub 릴리스에서 바로 받기" 패턴과 자연스럽고,
   poetry처럼 별도 인터프리터 경유가 없다.
3. 생태계 채택 추세: uv의 star/활동량이 poetry보다 뚜렷하게 앞서고, 2025-2026
   사이 python 진영에서 pip 대체 기본값으로 빠르게 확산 중 - "지금 새로 하나를
   고른다면" 시점에 더 방어 가능한 선택.
4. "둘 다 지원" 방안 기각 이유: 이 저장소는 nodejs→pnpm, java→gradle도 언어당
   companion 1개만 제안하는 기존 UX 패턴을 갖고 있다(lt_companion_for_plugin()이
   plugin당 공백구분 문자열 하나를 반환 - 이론상 여러 개도 가능하지만 지금까지
   실제로는 항상 1개). "동반 도구 선택 메뉴"까지 만드는 건 이 마일스톤(m-12)
   범위를 넘는 UX 추가 작업이며, 이 저장소가 "macOS 전용 개인 툴링"(범용 프로덕션
   도구 아님, README 명시)이라는 전제에 비춰 과설계로 판단.

## Consequences

- TASK-121.2에서 `lt_companion_for_plugin()`의 `python)` 케이스에 `uv`를 추가하고,
  `.tool-versions`에 `uv`의 기본 버전 항목을 추가한다.
- TASK-121.3에서 `lt_upstream_latest_version()`(TASK-119.1)에 `uv)` 케이스를
  추가한다 - GitHub Releases API(`astral-sh/uv/releases/latest`)를 쓴다. uv는
  공식 JSON 배포 인덱스가 따로 없어 decision-1의 "GitHub Releases API는 공식
  인덱스가 없는 도구에만 보조로 쓴다"는 원칙이 그대로 적용되는 첫 실제 사례다.
- poetry를 나중에 원하는 사용자는 여전히 `ask_version()`의 "Enter a specific
  version" 경로로 직접 pin 하거나, 이 저장소 밖에서 별도 관리할 수 있다 - 이
  결정은 "기본 제안"만 바꾸는 것이지 poetry 설치 자체를 막지 않는다.
