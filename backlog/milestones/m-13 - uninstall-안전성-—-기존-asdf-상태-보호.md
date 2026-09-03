---
id: m-13
title: "Uninstall 안전성 — 기존 asdf 상태 보호"
---

## Description

외부 리뷰(2026-08-30)에서 지적되고 코드로 확인된 Critical 이슈: scripts/uninstall/05_purge_asdf_core.sh가 $TARGET_ASDF_DATA_DIR(기본 ~/.asdf, 커스텀 ASDF_DATA_DIR도 인식)를 무조건 rm -rf한다. 코드 주석 자체가 "이 도구가 설치한 모든 런타임을 지운다"고 명시하고 있음.

문제: 이 도구를 설치하기 전부터 asdf를 다른 용도로 쓰고 있던 사용자가 langtoolchain을 테스트해보고 uninstall.sh를 실행하면, 이 도구가 건드리지 않은 기존 플러그인/런타임까지 통째로 사라져 대형 데이터 유실로 이어짐.

목표: uninstall이 "이 도구가 실제로 추가한 것"과 "원래 있던 것"을 구분해서, 원래 있던 asdf 상태는 보존하도록 삭제 범위를 축소한다.
