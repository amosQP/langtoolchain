---
id: decision-1
title: 'asdf 사전 상태 스냅샷: 저장 위치/형식'
date: '2026-09-03 01:05'
status: accepted
---
## Context

m-13(uninstall 안전성)의 목적은 uninstall이 langtoolchain 설치 전부터 사용자 머신에 있던 asdf
상태(asdf 자체, `$ASDF_DATA_DIR`, 그 안의 플러그인들)를 실수로 지우지 않게 하는 것이다
(TASK-124). 그러려면 install 시점에 "이 도구가 아무것도 건드리기 전 상태"를 어딘가 기록해 둬야
하고(TASK-123.1), uninstall이 그걸 다시 읽어 삭제 여부를 판단할 수 있어야 한다(TASK-124.1).

이 저장소엔 이미 비슷한 선례가 있다: `LT_REPORT_FILE`(TASK-107, 기본
`$HOME/.langtoolchain-report.log`) — install/uninstall이 실제로 바꾼 것들을 사람이 읽기 위한
감사 로그로 `$HOME` 바로 아래(= `$ASDF_DATA_DIR` 밖)에 남긴다. 이번 스냅샷은 목적이 다르다:
사람이 읽는 로그가 아니라 uninstall 스크립트가 파싱해서 조건 분기에 쓸 데이터이므로, 형식을
그 용도에 맞춰 별도로 정해야 한다.

이 프로젝트는 범용 프로덕션 도구가 아니라 "macOS 전용 개인 툴링"(README 명시)이라는 전제도
고려했다 — 별도 DB/JSON 파서 도입 같은 무거운 선택은 이 규모에 맞지 않는다.

## Decision

**저장 위치**: `$HOME/.langtoolchain-prior-asdf-state` (신규 상수 `LT_PRIOR_STATE_FILE`,
`LT_REPORT_FILE`과 동일하게 `${LT_PRIOR_STATE_FILE:-$HOME/...}` 형태로 테스트에서
오버라이드 가능). `LT_REPORT_FILE`과 똑같은 이유로 반드시 `$ASDF_DATA_DIR` 바깥에 둔다 —
uninstall의 `rm -rf "$TARGET_ASDF_DATA_DIR"`가 스냅샷 자체를 지워버리면 그 다음 줄에서 읽을
근거가 사라지는 자기모순이 생긴다.

**형식**: 사람이 읽기 위한 `lt_report()`의 타임스탬프 로그 형식과는 별도로, 파싱 전용의
단순한 `key=value` 줄 형식을 쓴다 (셸로 `source`/`eval` 하지 않고 `grep '^key='` + `cut -d= -f2-`
로만 읽는다 — 신뢰할 수 없는 입력을 eval하는 위험을 피하기 위함이며, 이 파일은 이 도구
자신만 쓰므로 애초에 적대적 입력을 걱정할 필요는 없지만 그래도 안전한 파싱 습관을 유지):

```
asdf_preexisting=true|false
asdf_data_dir=<lt_asdf_data_dir 반환값>
asdf_data_dir_preexisting=true|false
asdf_plugins_preexisting=<공백으로 구분된 플러그인 이름 목록, 없으면 빈 문자열>
```

`lib.sh`에 쓰기 함수(`lt_snapshot_prior_asdf_state`)와 읽기 함수(`lt_prior_state_get <key>`)를
한 쌍으로 둬서, uninstall 쪽(TASK-124.1)이 파일 형식을 직접 알 필요 없이 헬퍼만 호출하면
되게 한다. 스냅샷은 설치 1회당 딱 한 번만 쓴다 — 재설치/재실행 시 이미 파일이 있으면
덮어쓰지 않는다(그 시점엔 "이 도구가 건드리기 전" 상태가 이미 아니므로).

## Consequences

- uninstall(TASK-124.1)은 `lt_prior_state_get asdf_data_dir_preexisting` 같은 헬퍼 호출
  하나로 삭제 여부를 판단할 수 있다 — 파일 포맷이 바뀌어도 헬퍼 내부만 고치면 된다.
- 스냅샷 파일이 없는 경우(이 기능 도입 이전에 이미 설치했던 사용자, `--dry-run`만 실행했던
  경우 등)는 `lt_prior_state_get`이 실패(exit 1)로 신호하고, 호출부(TASK-124.1)는 이를
  "모르면 삭제하지 않는다"는 안전한 기본값으로 처리해야 한다.
- 스냅샷 파일은 uninstall이 끝나도 자동으로 지우지 않는다(`LT_REPORT_FILE`과 동일 원칙) —
  다음에 uninstall을 다시 돌릴 때도 여전히 유효한 "설치 전 상태" 기록으로 남아야 하고, 사용자가
  직접 지우고 싶다면 수동으로 지우면 된다.
- 새 공개 인터페이스(환경변수 오버라이드, 함수 2개)가 lib.sh에 추가된다 — 기존 `LT_REPORT_FILE`/
  `lt_report()` 패턴과 나란히 두므로 유지보수 부담은 작다.

