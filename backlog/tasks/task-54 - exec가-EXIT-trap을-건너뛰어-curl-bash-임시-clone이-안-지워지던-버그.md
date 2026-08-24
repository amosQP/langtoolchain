---
id: TASK-54
title: exec가 EXIT trap을 건너뛰어 curl|bash 임시 clone이 안 지워지던 버그
status: Done
assignee: []
created_date: '2026-08-24 13:03'
labels:
  - code-quality
  - bug
milestone: m-5
dependencies: []
modified_files:
  - install.sh
  - uninstall.sh
priority: medium
type: bug
ordinal: 54000
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
install.sh/uninstall.sh의 원격 설치 경로가 exec bash "$WORKDIR/.../main.sh" "$@" 형태였는데, exec는 execve로 프로세스 이미지를 통째로 교체해서 셸의 정상 종료 절차(EXIT trap 포함)를 건너뛴다. trap 'rm -rf "$WORKDIR"' EXIT는 그래서 성공 경로(사실상 curl|bash의 정상적인 경우 전부)에서 한 번도 실행되지 않았고, 임시 git clone이 $TMPDIR에 영구히 쌓였다. exec를 제거하고 일반 호출 + exit $?로 교체. 실제 GitHub에서 git clone까지 실행해 정리되는 것 확인.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 성공적으로 완료된 curl|bash 설치/제거 후 $TMPDIR에 clone 디렉토리가 남지 않는다 (실제 git clone으로 검증 완료)
<!-- AC:END -->
