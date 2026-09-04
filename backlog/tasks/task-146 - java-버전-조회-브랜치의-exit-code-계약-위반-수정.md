---
id: TASK-146
title: java 버전 조회 브랜치의 exit code 계약 위반 수정
status: To Do
assignee: []
created_date: '2026-09-04 08:57'
labels: []
milestone: m-17
dependencies: []
priority: medium
type: bug
ordinal: 217000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
/code-review high가 발견: scripts/lib.sh의 lt_upstream_latest_version() java 브랜치에서
`if [ -n "$semver" ]; then printf ...; fi` 형태로만 작성돼 있고 else 분기가 없다. POSIX
if/fi 의미상 조건이 거짓이고 아무 분기도 안 돌면 그 자체의 종료 상태는 0(성공)이다 —
그래서 semver가 빈 문자열(Adoptium 응답이 비정상/파싱 실패)이면 함수가 exit 0 + 빈
출력을 반환해서, 함수 자신의 문서화된 계약("실패 시 1 반환, 파싱 불가 시 포함")을
위반한다.

지금은 유일한 호출부(lt_resolve_default_version)가 exit code 대신 [ -n "$fetched" ]로
빈 문자열 여부만 체크해서 우연히 안 드러나 있지만, 계약을 그대로 믿는 새 호출부가 추가되면
빈 문자열을 유효한 버전으로 오인할 수 있는 잠재적 함정이다. else 분기에 return 1 추가.
<!-- SECTION:DESCRIPTION:END -->
