#!/usr/bin/env bash
# Interactive language/version picker.
#
# Prints nothing but a single file path to stdout on success (the resulting
# .tool-versions-style selection file) — every prompt and menu line goes to
# /dev/tty instead, so this script is safe to call via command substitution
# (`SELECTION_FILE="$(bash 00_select.sh)"`).
#
# Flags:
#   --all   skip the menu, select every language at its default version
#   --yes   skip the final "install these?" confirmation
#
# If there is no controlling terminal at all (CI, fully non-interactive
# pipes), falls back to --all behavior automatically instead of hanging on
# a `read` that can never return.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
DEFAULT_CONFIG="$REPO_ROOT/.tool-versions"
[[ -f "$DEFAULT_CONFIG" ]] || die "Config file not found: $DEFAULT_CONFIG"

SELECT_ALL=false
AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    --all) SELECT_ALL=true ;;
    --yes) AUTO_YES=true ;;
  esac
done

INTERACTIVE=true
{ : < /dev/tty; } 2>/dev/null || INTERACTIVE=false

tty_out() { printf '%s\n' "$*" > /dev/tty; }
tty_prompt() { printf '%s' "$*" > /dev/tty; }

OUT_FILE="$(mktemp -t langtoolchain-selection)"
trap '[[ -s "$OUT_FILE" ]] || rm -f "$OUT_FILE"' EXIT

if ! $INTERACTIVE || $SELECT_ALL; then
  cp "$DEFAULT_CONFIG" "$OUT_FILE"
  echo "$OUT_FILE"
  exit 0
fi

: > "$OUT_FILE"

tty_out ""
tty_out "== 설치할 언어를 선택하세요 (Enter = 예) =="

# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why
# (the /dev/tty reads below are already redirected per-command so they're
# safe either way, but fd 3 keeps every loop in this codebase consistent).
while read -r plugin default_version <&3; do
  cmd="$(binary_for_plugin "$plugin")"
  tty_out ""
  tty_prompt "$plugin ($cmd) 설치할까요? [Y/n] > "
  read -r answer < /dev/tty || answer=""
  case "$answer" in
    n|N|no|NO) continue ;;
  esac

  tty_prompt "  버전 [기본값: $default_version] > "
  read -r version < /dev/tty || version=""
  [[ -n "$version" ]] || version="$default_version"

  printf '%s %s\n' "$plugin" "$version" >> "$OUT_FILE"
done 3< <(each_tool "$DEFAULT_CONFIG")

if [[ ! -s "$OUT_FILE" ]]; then
  tty_out ""
  tty_out "선택된 언어가 없습니다. 설치를 취소합니다."
  exit 1
fi

tty_out ""
tty_out "== 설치 목록 =="
while read -r plugin version; do
  tty_out "  $plugin  $version"
done < "$OUT_FILE"
tty_out ""

if ! $AUTO_YES; then
  tty_prompt "설치할까요? [Y/n] > "
  read -r confirm < /dev/tty || confirm=""
  case "$confirm" in
    n|N|no|NO) tty_out "취소되었습니다."; exit 1 ;;
  esac
fi

echo "$OUT_FILE"
