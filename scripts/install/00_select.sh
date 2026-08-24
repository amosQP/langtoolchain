#!/usr/bin/env bash
# Interactive language/version picker.
#
# Prints nothing but a single file path to stdout on success (the resulting
# .tool-versions-style selection file) — every prompt and menu line goes to
# /dev/tty instead, so this script is safe to call via command substitution
# (`SELECTION_FILE="$(bash 00_select.sh)"`).
#
# Flags:
#   --all         skip the menu, select every language at its default version
#   --yes         skip the final "install these?" confirmation
#   --local[=DIR] pin to DIR (default: current directory) instead of asking;
#                 skips the interactive global/local prompt too
#
# If there is no controlling terminal at all (CI, fully non-interactive
# pipes), falls back to --all behavior automatically instead of hanging on
# a `read` that can never return. Pin scope likewise defaults to global
# when there's no tty to ask.

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
# SCOPE is empty until either a --local flag or the interactive prompt
# (further below) sets it to "global" or "local".
SCOPE=""
SCOPE_DIR=""
for arg in "$@"; do
  case "$arg" in
    --all) SELECT_ALL=true ;;
    --yes) AUTO_YES=true ;;
    --local) SCOPE="local"; SCOPE_DIR="$(pwd)" ;;
    --local=*) SCOPE="local"; SCOPE_DIR="${arg#--local=}" ;;
    # (unrecognized flags are silently ignored here — main.sh validates them)
  esac
done

if [[ "$SCOPE" == "local" ]]; then
  [[ -d "$SCOPE_DIR" ]] || die "Directory not found: $SCOPE_DIR"
  # Resolve to an absolute path now, once, so 06_set_globals.sh (running
  # later, as its own process, possibly with a different cwd) gets an
  # unambiguous path regardless of where it happens to be invoked from.
  SCOPE_DIR="$(cd "$SCOPE_DIR" && pwd)"
fi

# scope_line: the "# scope: ..." line written as the first line of the
# output file — a comment, so each_tool's plugin/version parsing (which
# skips lines starting with '#') never has to know this exists.
scope_line() {
  if [[ "$SCOPE" == "local" ]]; then
    printf '# scope: local %s\n' "$SCOPE_DIR"
  else
    printf '# scope: global\n'
  fi
}

# write_with_scope <source-file> <dest-file>: prepends the scope line
# ahead of <source-file>'s content into <dest-file>.
write_with_scope() {
  { scope_line; cat "$1"; } > "$2"
}

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
# Clean up on every exit path except the one deliberate success below.
# Emptiness alone isn't a reliable signal here: the interactive scope
# prompt can `die` (e.g. on an invalid --local directory) *after*
# language selections are already written to $OUT_FILE, which would look
# "successful" to an emptiness check and leak the file. SUCCESS is only
# ever set true right before the two real `echo "$OUT_FILE"` handoffs.
SUCCESS=false
trap '$SUCCESS || rm -f "$OUT_FILE"' EXIT

# Non-interactive session, or the caller explicitly asked for everything:
# skip the language menu entirely and use the default config as-is. Scope
# still comes from --local if given; otherwise there's no tty to ask, so
# it defaults to global (scope_line() already does this when SCOPE="").
if ! $INTERACTIVE || $SELECT_ALL; then
  write_with_scope "$DEFAULT_CONFIG" "$OUT_FILE"
  SUCCESS=true
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

# Ask where to pin these versions, unless --local[=DIR] already decided it.
if [[ -z "$SCOPE" ]]; then
  tty_prompt "전역으로 고정할까요, 이 디렉토리에만 고정할까요? [전역/로컬] > "
  read -r scope_answer < /dev/tty || scope_answer=""
  case "$scope_answer" in
    로컬|local|Local|l|L)
      tty_prompt "  어느 디렉토리에 고정할까요? [기본값: 현재 디렉토리] > "
      read -r scope_dir_answer < /dev/tty || scope_dir_answer=""
      SCOPE_DIR="${scope_dir_answer:-$(pwd)}"
      [[ -d "$SCOPE_DIR" ]] || die "Directory not found: $SCOPE_DIR"
      SCOPE_DIR="$(cd "$SCOPE_DIR" && pwd)"
      SCOPE="local"
      ;;
    *)
      SCOPE="global"
      ;;
  esac
fi

if ! $AUTO_YES; then
  tty_prompt "설치할까요? [Y/n] > "
  read -r confirm < /dev/tty || confirm=""
  case "$confirm" in
    n|N|no|NO) tty_out "취소되었습니다."; exit 1 ;;
  esac
fi

# Prepend the scope line now that it's finally settled (flag or prompt).
SCOPE_TMP="$(mktemp)"
write_with_scope "$OUT_FILE" "$SCOPE_TMP"
mv "$SCOPE_TMP" "$OUT_FILE"

# The ONLY thing written to real stdout: the path main.sh should read the
# final selection from.
SUCCESS=true
echo "$OUT_FILE"
