---
id: TASK-117.3
title: asdf 플러그인 소스 커밋 고정 여부 검토
status: Done
assignee: []
created_date: '2026-08-30 11:33'
updated_date: '2026-09-03 01:20'
labels: []
dependencies: []
references:
  - decision-2
documentation:
  - docs/download-points-inventory.md
parent_task_id: TASK-117
type: task
ordinal: 137000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
scripts/install/02_install_plugins.sh:55 — asdf plugin add "$plugin" 는 내부적으로 플러그인 저장소(예: asdf-nodejs, asdf-python)를 git clone하며, 커밋 SHA나 버전 고정 없이 항상 최신 HEAD를 받는다.

asdf 자체가 plugin add에 커밋 고정 옵션(예: asdf plugin add <name> [git-url] [ref])을 제공하는지 확인하고, 제공한다면 이 저장소가 알려진-안전 버전의 플러그인 저장소 참조를 고정할지 결정. 플러그인 업데이트 빈도/이 저장소의 유지보수 부담과 트레이드오프가 있으므로 "지금 당장 고정" 대신 "검토 후 결정 기록"이 결과물일 수 있음.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 asdf plugin add의 ref 고정 가능 여부가 확인되고 문서화됨
- [x] #2 고정하기로 결정하면 실제 적용, 하지 않기로 결정하면 근거가 backlog decision 또는 README에 기록됨
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
asdf 0.20.0(Go 재작성) 소스 확인: internal/cli/cli.go의 pluginAddCommand가 plugins.Add(conf, name, url, "")를 호출 — ref 인자가 하드코딩된 빈 문자열이라 plugin add에 ref를 넘길 CLI 경로가 없음(내부 함수/plugin test의 --asdf-plugin-gitref만 ref를 씀). 설령 채워도 internal/git/git.go의 Clone은 --depth 1 shallow + --branch(SHA 아닌 브랜치/태그만)라 이중 제약. decision-2로 '지금 고정하지 않음'을 기록하고 docs/download-points-inventory.md #5를 '통제 밖(문서화만)'으로 재분류.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
asdf plugin add의 ref 고정 가능 여부를 asdf 0.20.0 소스로 직접 확인 — CLI가 ref를 노출하지 않고(pluginAddCommand가 항상 빈 문자열 전달), 내부 clone도 --depth 1 shallow + --branch(SHA 미지원)라 사후 고정도 어려움. decision-2로 '지금 고정하지 않음'을 기록하고 근거(asdf CLI 제약, 5개 플러그인 각각의 pin 유지보수 부담, 매 실행마다 plugin update --all이 이미 최신화하는 구조)를 남김. docs/download-points-inventory.md #5를 통제 밖으로 재분류.
<!-- SECTION:FINAL_SUMMARY:END -->
