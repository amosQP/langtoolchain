---
id: TASK-128.1
title: lib.sh에 언어별 전체 버전 목록 조회 헬퍼 추가
status: To Do
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 04:43'
labels: []
dependencies: []
parent_task_id: TASK-128
type: task
ordinal: 174000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
node/pnpm/java/gradle/python/rust/golang/uv 각각에 대해 설치 가능한 버전 전체 목록을
반환하는 헬퍼를 lib.sh에 추가한다. TASK-119.1의 기본값(1개) 헬퍼(lt_upstream_latest_
version())와 동일한 case-dispatch 스타일을 따르되, 별도 함수(예:
lt_upstream_version_list())로 분리한다 — decision-15에서 확인된 대로 asdf 명령이
아니라 언어 공식 메타데이터/API를 그대로 재사용한다(golang은 go.dev/dl/?mode=json이
이미 전체 배열 반환, python은 git ls-remote --tags 전체 태그에서 필터링 방식만
바꾸면 됨, gradle/pnpm/uv는 "전체 버전" 자매 엔드포인트 사용, java/Adoptium은 여러
LTS major 나열).

**rust는 예외** — 현재 기본값 조회가 쓰는 channel-rust-stable.toml 소스는 최신 버전
하나만 주므로, 목록 조회엔 다른 소스(예: rust 공식 GitHub 릴리스 태그, 또는
static.rust-lang.org의 dist 인덱스)를 새로 찾아야 한다. 실측 확인 후 결정 근거를
task notes에 남길 것.

**decision-15가 남긴 갭 처리 필요**: 언어 공식 소스의 "설치 가능"과 asdf 플러그인이
실제로 설치 가능한 버전이 항상 일치하지 않을 수 있다(decision-12). 이 헬퍼 자체가
그 교차검증까지 할 필요는 없지만(범위가 커짐), 함수 주석에 이 한계를 명시하고, 목록에
사용자가 고를 수 있는 버전이 실제로 asdf에서 실패할 수 있다는 걸 TASK-129(UI)가
어떻게 다룰지에 대한 참고를 남겨둘 것.
<!-- SECTION:DESCRIPTION:END -->
