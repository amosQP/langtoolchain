---
id: TASK-128.1
title: lib.sh에 언어별 전체 버전 목록 조회 헬퍼 추가
status: Done
assignee: []
created_date: '2026-09-03 01:18'
updated_date: '2026-09-05 08:51'
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

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
lt_upstream_version_list() 신규 함수 추가 (scripts/lib.sh, lt_upstream_latest_version()
바로 뒤). 기존 함수는 전혀 수정하지 않음 - 별도 함수로 완전히 분리(decision-15/128.1 지시대로).

## rust 목록 소스 선정 근거 (실측)
기존 단일값 소스(static.rust-lang.org/dist/channel-rust-stable.toml)는 최신 1개만 제공.
후보 2개를 실측 비교:
- static.rust-lang.org/dist/ 디렉터리 리스팅: 존재하지 않음 - 실제로 curl -I 해보면 S3가
  416(Range Not Satisfiable)을 반환, 순수 오브젝트 스토리지라 인덱스 페이지가 없음.
- GitHub Releases API (api.github.com/repos/rust-lang/rust/releases): 실측 결과
  per_page=100으로 최근 100개 릴리스 전부 정상 반환, tag_name이 전부 "1.98.1" 형태의
  순수 X.Y.Z(v 접두사 없음, prerelease=false) - asdf-rust 버전 포맷과 그대로 일치,
  재포맷 불필요. decision-4가 uv(공식 JSON 인덱스 없는 도구)에 이미 채택한 "GitHub
  Releases를 대체 소스로" 패턴과 동일 - rust도 "목록 조회"라는 관점에서는 같은 처지.
=> GitHub Releases API 채택. per_page=100(1페이지, 최근 ~2년치)만 사용하고 페이지네이션은
안 함 - decision-16의 "lazy, 1회성 조회, 전체 prefetch 안 함" 원칙을 페이지네이션에도
동일 적용(개인 도구 버전 피커에 10년 전 릴리스까지 볼 필요 없다고 판단).

## 나머지 7개 소스 실측 확인
- nodejs: nodejs.org/dist/index.json 전체 배열(863개) 그대로 사용 - 단일값 브랜치와
  달리 "lts" 패스스루 불가(별칭이라 목록에 없음)해서 유일하게 새로 네트워크 호출 추가.
- pnpm: registry.npmjs.org/pnpm (install-v1 abbreviated Accept 헤더, 전체 문서 5.6MB
  -> 1.87MB로 축소) - "versions" 객체 키에서 순수 X.Y.Z만 grep, dev/beta 태그 제외,
  BSD sort -V 없어서 수동 numeric sort.
- gradle: services.gradle.org/versions/all (전체 524개, snapshot/rc/milestone 포함) -
  snapshot=false && rcFor=="" && milestoneFor=="" 만 필터(실측 180개 GA), awk 상태
  머신으로 파싱(RS 정규식은 gawk 확장이라 미사용).
- golang: go.dev/dl/?mode=json&include=all (기본 mode=json은 최신 2개만 줌) - 최상위
  "version"/"stable" 필드만(중첩 files[] 안의 동일 필드명과 들여쓰기로 구분).
- python: 기존 git ls-remote --tags 그대로, tail -1 제거하고 전체 정렬.
- java: available_releases의 available_lts_releases 배열(8/11/17/21/25) 순회하며 각
  major의 assets/latest 호출 - major 8은 실측 결과 이 Mac(aarch64)용 JDK 빌드가 없어서
  빈 배열 반환됨을 확인, 조용히 skip 처리(전체 실패로 안 만듦).

## 버그 수정 (개발 중 발견)
java 브랜치 초안에서 `[ -n "$semver" ] && printf ...`를 루프 마지막 줄에 썼더니, 마지막
메이저(가장 오래된 LTS, 역순 정렬 후 리스트의 끝)가 skip될 때 그 실패 exit status가 함수
전체의 exit status로 새버림 - 실제로는 4개 버전을 성공 출력했는데 함수는 실패(1)로
리턴되는 버그를 실측으로 발견, `if` 문으로 교체해 수정. 동시에 "모든 major가 실패하면
빈 출력 + exit 0"이 되는 것도 발견해 found 플래그로 명시적 return 1 처리 추가.

## 테스트
spec/lib_spec.sh에 lt_upstream_version_list() Describe 블록 추가(11개 example, 전부
curl/git Mock, 실제 네트워크 미사용). 8개 플러그인 분기 + unknown-plugin 실패 + 네트워크
실패 케이스 + "모든 LTS major 실패" 엣지케이스 커버. bash/dash 양쪽 shellspec 통과
(113 examples, 0 failures - 기존 102개에서 +11). shellcheck -s sh: 기존 베이스라인
(SC2034/SC3043/SC2155) 외 신규 경고 0건. dash -n 통과.
<!-- SECTION:NOTES:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
scripts/lib.sh에 lt_upstream_version_list(plugin) 신규 추가 - node/pnpm/java/gradle/
python/rust/golang/uv 8개 전부, asdf 무관(decision-15), 기존 lt_upstream_latest_
version()/lt_resolve_default_version()은 완전히 손대지 않음. rust는 실측 후
GitHub Releases API(api.github.com/repos/rust-lang/rust/releases)를 신규 목록
소스로 채택(근거는 task notes 참고 - static.rust-lang.org는 디렉터리 리스팅이
없음을 확인). spec/lib_spec.sh에 11개 example 추가, bash/dash 양쪽 shellspec
113 examples 0 failures(기존 102 -> 113), shellcheck 신규 경고 0건. 개발 중
java 브랜치에서 마지막 LTS major가 skip될 때 함수 전체 exit status가 잘못
실패로 새는 버그를 실측으로 발견해 수정.
<!-- SECTION:FINAL_SUMMARY:END -->
