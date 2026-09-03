---
id: TASK-126
title: sed 사용 지점 BSD/GNU 이식성 전수 감사
status: Done
assignee: []
created_date: '2026-09-03 01:15'
updated_date: '2026-09-03 06:08'
labels: []
milestone: m-14
dependencies: []
type: task
ordinal: 166000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
이 저장소는 macOS 전용이지만 개발/CI 환경(GitHub Actions macOS 러너 vs 로컬 macOS vs 잠재적 Linux 개발 환경)에 따라 sed가 BSD sed(/bin/sed, macOS 기본)일 수도 GNU sed일 수도 있다. BSD/GNU 문법 차이(특히 -i 인자 방식: BSD는 -i '' 필수, GNU는 -i만으로 동작)로 인한 이식성 버그는 이 클래스의 회귀가 아직 이 저장소에서 실제로 발견된 적은 없지만, 예방적으로 감사한다.

자식 태스크 순서: 126.1(sed 호출 지점 전수 목록화) -> 126.2(각 지점 BSD/GNU 위험 평가, 반드시 이 macOS 개발 머신의 실제 /bin/sed로 검증) -> 126.3(위험 지점 수정 또는 안전 확인 후 감사 결과 문서화).

126.3에서 위험이 없다고 판단되면 억지로 코드를 고치지 않고 감사 결과만 final summary에 남기고 종료.
<!-- SECTION:DESCRIPTION:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
3개 자식 태스크 전부 완료. 126.1: 저장소 전체(scripts/, spec/, .github/, install.sh, uninstall.sh) 전수 검색 결과 실제 sed 호출은 scripts/lib.sh:601(읽기전용 BRE)과 scripts/uninstall/03_clean_env_vars.sh:61(-E -i '.bak') 2곳뿐. 126.2: 이 macOS 개발 머신의 실제 /usr/bin/sed(BSD sed)로 두 호출을 직접 실행 검증 - 둘 다 안전. 참고로 -i 뒤 접미사 인자를 생략하면 BSD sed가 다음 토큰(-e 등)을 접미사로 삼켜버리는 실제 함정을 재현했고, 기존 코드는 이미 .bak를 명시해 이를 피하고 있음을 확인. 126.3: 위험 지점이 없어 코드 수정 없이 감사 결과만 scripts/lint/sed-portability-audit.md에 문서화하고 종료 - 없는 문제를 만들어 고치지 않음. 기존 shellspec 스위트 132 examples 0 failures로 회귀 없음 확인(애초에 코드 변경 없었음).
<!-- SECTION:FINAL_SUMMARY:END -->
