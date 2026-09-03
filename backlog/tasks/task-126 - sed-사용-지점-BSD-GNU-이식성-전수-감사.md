---
id: TASK-126
title: sed 사용 지점 BSD/GNU 이식성 전수 감사
status: To Do
assignee: []
created_date: '2026-09-03 01:15'
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
