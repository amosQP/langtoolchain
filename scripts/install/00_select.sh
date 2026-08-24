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

# -e: any unhandled non-zero exit kills the script. -u: referencing an
# unset variable is an error. -o pipefail: a pipeline fails if ANY stage
# fails, not just the last one.
set -euo pipefail

# Resolve this script's own directory, regardless of the caller's cwd, so
# `. lib.sh` below always finds the right file.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Pull in log/step/die/run/each_tool/binary_for_plugin/etc.
. "$SCRIPT_DIR/../lib.sh"

# Two directories up from scripts/install/ is the repo root.
REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
# The shipped, default list of languages/versions this repo installs.
DEFAULT_CONFIG="$REPO_ROOT/.tool-versions"
# Bail out early with a clear message if the repo is somehow missing it.
[[ -f "$DEFAULT_CONFIG" ]] || die "Config file not found: $DEFAULT_CONFIG"

# Flags default to off; the loop below flips them on if passed.
SELECT_ALL=false
AUTO_YES=false
for arg in "$@"; do
  case "$arg" in
    --all) SELECT_ALL=true ;;
    --yes) AUTO_YES=true ;;
    # (unrecognized flags are silently ignored here — main.sh validates them)
  esac
done

# Probe for a controlling terminal. `: < /dev/tty` tries to open /dev/tty
# for reading and does nothing with it (`:` is the no-op builtin); if that
# open fails (no tty — e.g. cron, CI, or this being piped through something
# with no terminal at all), the `||` sets INTERACTIVE=false instead of
# letting `set -e` kill the script.
INTERACTIVE=true
{ : < /dev/tty; } 2>/dev/null || INTERACTIVE=false

# tty_out/tty_prompt: write straight to the terminal device, bypassing this
# script's own stdout. That keeps stdout free to carry only the final
# result (the selection file path) back to whoever called this script via
# `$(...)`, even while stdin is something else entirely (a curl pipe).
tty_out() { printf '%s\n' "$*" > /dev/tty; }
tty_prompt() { printf '%s' "$*" > /dev/tty; }   # no trailing newline: prompt stays on the input line

# Create the file the selection will be written to. `-t` gives it a
# predictable prefix under the system temp dir (e.g. /tmp on Linux,
# $TMPDIR on macOS) with a random unique suffix.
OUT_FILE="$(mktemp -t langtoolchain-selection)"
# Clean up on ANY exit path (success, error, or the user backing out) —
# but only if we're leaving it empty; a populated file is the return value
# the caller still needs to read.
trap '[[ -s "$OUT_FILE" ]] || rm -f "$OUT_FILE"' EXIT

# Non-interactive session, or the caller explicitly asked for everything:
# skip the menu entirely and just copy the default config as-is.
if ! $INTERACTIVE || $SELECT_ALL; then
  cp "$DEFAULT_CONFIG" "$OUT_FILE"
  echo "$OUT_FILE"   # the one line of "real" stdout output
  exit 0
fi

# Interactive path: start the selection file empty and build it up below.
: > "$OUT_FILE"

tty_out ""
tty_out "== 설치할 언어를 선택하세요 (Enter = 예) =="

# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why
# (the /dev/tty reads below are already redirected per-command so they're
# safe either way, but fd 3 keeps every loop in this codebase consistent).
# `each_tool` prints "plugin version" pairs for every language in the
# default config; process substitution `<( ... )` feeds them in on fd 3
# instead of the loop's own stdin (fd 0).
while read -r plugin default_version <&3; do
  # Just for a friendlier prompt line, e.g. "nodejs (node)".
  cmd="$(binary_for_plugin "$plugin")"
  tty_out ""
  tty_prompt "$plugin ($cmd) 설치할까요? [Y/n] > "
  # Read the answer straight from the terminal device, not this loop's fd
  # 3/fd 0 — `|| answer=""` treats Ctrl-D / a closed tty as "no answer" so
  # the script degrades gracefully instead of erroring under `set -e`.
  read -r answer < /dev/tty || answer=""
  case "$answer" in
    n|N|no|NO) continue ;;   # skip this language entirely; move to the next
  esac

  tty_prompt "  버전 [기본값: $default_version] > "
  read -r version < /dev/tty || version=""
  # Empty input (plain Enter) means "use the default version".
  [[ -n "$version" ]] || version="$default_version"

  # Record this language/version as one line of the selection file.
  printf '%s %s\n' "$plugin" "$version" >> "$OUT_FILE"
done 3< <(each_tool "$DEFAULT_CONFIG")

# `-s` = file exists and is non-empty. If the user answered "n" to every
# single language, there's nothing to install — stop here instead of
# silently proceeding with an empty plan.
if [[ ! -s "$OUT_FILE" ]]; then
  tty_out ""
  tty_out "선택된 언어가 없습니다. 설치를 취소합니다."
  exit 1
fi

# Recap what was selected before asking for final confirmation.
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

# The ONLY thing written to real stdout: the path main.sh should read the
# final selection from.
echo "$OUT_FILE"
