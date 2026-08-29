---
id: m-7
title: "언어별 동반 도구 지원 (pnpm/gradle)"
---

## Description

실제 맥북에서 uninstall→install 재설치를 시도하려다가, 이 도구가 관리하지 않는 pnpm/gradle까지 uninstall이 통째로 지워버리는데 재설치 시 복구가 안 된다는 게 확인되면서 나온 기능 요청. nodejs의 동반 패키지 매니저 pnpm, java의 동반 빌드 도구 gradle을 이 도구가 직접 관리하도록 확장. rust/go는 조사 결과 asdf 플러그인이 cargo/go tool을 이미 번들로 포함해서 pnpm/gradle과 같은 급의 '별도 동반 도구'가 없음 — 사용자에게 이 사실을 설명하고 필요시 확장 가능한 구조로만 만들어둠. 구현 전 계획 단계(백로깅)만, 실제 코드 작업은 각 태스크 착수 시.
