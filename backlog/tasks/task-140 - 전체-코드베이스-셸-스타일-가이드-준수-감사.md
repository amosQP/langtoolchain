---
id: TASK-140
title: 전체 코드베이스 셸 스타일 가이드 준수 감사
status: Done
assignee: []
created_date: '2026-09-03 12:07'
updated_date: '2026-09-03 22:32'
labels: []
milestone: m-16
dependencies: []
references:
  - TASK-71
priority: low
type: task
ordinal: 205000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
사용자 요청(2026-09-03): "쉘 컨벤션 구글꺼 가져와서 적용하고 파일로갖고있어. 지금만든
코드가 읽기쉬운가? 이프로젝트 전체에." docs/shell-style-guide.md(방금 작성, TASK-71
정책을 문서화한 것)를 기준으로 저장소 전체 .sh 파일이 실제로 그 규칙을 지키는지 감사한다.
TASK-71/72~76(m-5)에서 최초 전환은 됐지만, 그 이후(m-6~m-16) 수십 개 태스크가 코드를
계속 추가/수정해왔고 그중 다수가 서로 다른 서브에이전트가 작성한 것이라 스타일 일관성이
실제로 유지되고 있는지 별도 확인된 적이 없다.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
shell-style-guide.md(TASK-71 정책 문서화) 기준으로 저장소 전체 .sh 파일(scripts/**, install.sh, uninstall.sh, spec/**, 총 39개) 스타일 준수 감사 완료.

TASK-140.1(스캔): 라인 길이/탭/들여쓰기/네이밍/주석 헤더/따옴표를 기계적으로 스캔. 탭·들여쓰기·함수 네이밍·readonly 선언부 네이밍·백틱·eval·local+명령치환 분리·shebang·따옴표는 전부 위반 0건. 반면 라인 길이 80자 초과 229건(30/39 파일), ALL_CAPS 변수 156건이 readonly/export 없이 선언, 라이브러리 함수 60/60개가 Globals/Arguments/Outputs/Returns 헤더 대신 기존 산문형 설명 주석 컨벤션 사용 — 이 3개는 저장소 전반에 걸친 광범위/구조적 패턴으로 확인됨.

TASK-140.2(분류/처리): 위 3개 광범위 항목은 이 감사 태스크의 스코프(국소 스타일 수정)를 벗어나 직접 고치지 않고 TASK-141(라인 길이), TASK-142(ALL_CAPS readonly/export 정책), TASK-143(함수 헤더 주석 정책 재검토)으로 분리 백로깅했다. 그 외 카테고리는 위반이 없어 이 태스크에서 실제로 수정한 코드는 없다(위반 없음도 유효한 결과).

코드 변경이 없어 shellspec 전후 비교는 해당 없음. 다만 작업 착수 전 main 브랜치의 85개 미반영 커밋을 fast-forward 병합(TASK-140/140.1/140.2 원본과 shell-style-guide.md를 포함해 이 워크트리에 없던 최신 상태를 반영하기 위함)한 뒤 shellspec 전체 스위트를 bash/dash 양쪽으로 돌려 177 examples, 0 failures로 베이스라인 정상 확인.
<!-- SECTION:FINAL_SUMMARY:END -->
