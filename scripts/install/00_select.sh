#!/usr/bin/env sh
# Interactive language/version picker.
#
# Prints nothing but a single file path to stdout on success (the resulting
# .tool-versions-style selection file) — every prompt and menu line goes to
# /dev/tty instead, so this script is safe to call via command substitution
# (`SELECTION_FILE="$(sh 00_select.sh)"`).
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
# unset variable is an error. (No pipefail — that's a bash/ksh/zsh
# extension, not POSIX; dash doesn't have it. This script avoids relying on
# it — see the fd-3 process-substitution replacement below for why piping
# straight into a loop was already avoided regardless.)
set -eu

# Resolve this script's own directory, regardless of the caller's cwd, so
# `. lib.sh` below always finds the right file. $0 (not ${BASH_SOURCE[0]}
# — POSIX sh has no BASH_SOURCE) works here because every caller always
# invokes this script by path (never a bare name looked up on PATH).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Pull in log/step/die/run/each_tool/binary_for_plugin/etc.
. "$SCRIPT_DIR/../lib.sh"

# Two directories up from scripts/install/ is the repo root.
REPO_ROOT="$(repo_root_from "$0")"
# The shipped, default list of languages/versions this repo installs.
DEFAULT_CONFIG="$REPO_ROOT/.tool-versions"
# Bail out early with a clear message if the repo is somehow missing it.
[ -f "$DEFAULT_CONFIG" ] || die "Config file not found: $DEFAULT_CONFIG"

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

# resolve_scope_dir <dir>: validates <dir> exists, then prints its absolute
# path — resolved now, once, so 06_set_globals.sh (running later, as its own
# process, possibly with a different cwd) gets an unambiguous path
# regardless of where it happens to be invoked from. Shared by both the
# --local=DIR flag path here and the interactive local-scope prompt below.
resolve_scope_dir() {
  [ -d "$1" ] || die "Directory not found: $1"
  ( cd "$1" && pwd )
}

if [ "$SCOPE" = "local" ]; then
  SCOPE_DIR="$(resolve_scope_dir "$SCOPE_DIR")"
fi

# scope_line: the "# scope: ..." line written as the first line of the
# output file — a comment, so each_tool's plugin/version parsing (which
# skips lines starting with '#') never has to know this exists.
scope_line() {
  if [ "$SCOPE" = "local" ]; then
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

# Probe for a controlling terminal. `true < /dev/tty` tries to open
# /dev/tty for reading and does nothing with it; if that open fails (no
# tty — e.g. cron, CI, or this being piped through something with no
# terminal at all), the `||` sets INTERACTIVE=false. Uses `true`, not `:` —
# POSIX mandates that a redirection error on a *special* built-in (`:` is
# one) unconditionally kills a non-interactive shell script, bypassing
# `set -e`/`||` entirely; `true` is an ordinary command, so its redirection
# failure is just a normal non-zero status the `||` can catch.
INTERACTIVE=true
{ true < /dev/tty; } 2>/dev/null || INTERACTIVE=false

# tty_out/tty_prompt: write straight to the terminal device, bypassing this
# script's own stdout. That keeps stdout free to carry only the final
# result (the selection file path) back to whoever called this script via
# `$(...)`, even while stdin is something else entirely (a curl pipe).
tty_out() { printf '%s\n' "$*" > /dev/tty; }
tty_prompt() { printf '%s' "$*" > /dev/tty; }   # no trailing newline: prompt stays on the input line

# ANSI escape building blocks for lt_arrow_menu below, and the raw-mode
# safety net: _LT_RAW_STTY holds the terminal's pre-raw-mode settings
# whenever a menu is actually mid-read, so the EXIT trap (registered after
# OUT_FILE below) can restore it even if a signal interrupts mid-keypress -
# without this, Ctrl-C during a menu would leave the terminal stuck in raw/
# no-echo mode (typing invisible, no line editing) for the rest of the
# session. `printf '\033[...'` (not `tput`) - this repo has no other tput
# dependency and printf's escapes are simpler to reason about here.
_LT_ESC="$(printf '\033')"
_LT_CYAN="$(printf '\033[36m')"
_LT_GREEN="$(printf '\033[32m')"
_LT_DIM="$(printf '\033[2m')"
_LT_BOLD="$(printf '\033[1m')"
_LT_RESET="$(printf '\033[0m')"
_LT_RAW_STTY=""
lt_restore_raw_stty() {
  # Always exits 0 - this runs from the EXIT trap, where a failing command
  # would otherwise override the script's actual exit status (the whole
  # point of `$SUCCESS || rm -f "$OUT_FILE"` right after it is to preserve
  # that status, which a failure here would clobber). The common case -
  # nothing was ever put into raw mode - is not an error, just a no-op.
  if [ -n "$_LT_RAW_STTY" ]; then
    stty "$_LT_RAW_STTY" < /dev/tty 2>/dev/null || true
  fi
}

# lt_arrow_menu <question> <default-index 1-based> <option...> (m-10/
# TASK-106 v2): a real arrow-key-navigable menu, drawn and read straight
# against /dev/tty — Up/Down moves the highlighted option, Enter confirms,
# a bare digit jumps straight to that option. Redraws the whole block in
# place (cursor-up + reprint) on every keypress, clack-prompts-style, then
# collapses it to a single "✔ <question> <chosen>" summary line once
# confirmed. Prints the chosen option's 1-based index to stdout.
#
# Reads one raw keypress at a time via `stty -icanon -echo` (put the tty in
# non-canonical mode) + `dd bs=1 count=1` (read exactly one byte) — NOT
# bash's `read -n1`, which POSIX sh has no equivalent of and dash flatly
# rejects ("Illegal option -n"). `stty`/`dd` are ordinary external commands
# with no such gap, so this works identically under dash — verified against
# a real dash process over an actual pty (not just bash) before landing.
# Escape sequences for arrow keys are 3 bytes (ESC, `[`, `A`/`B`); a lone
# byte that isn't ESC is either Enter (empty read) or a digit shortcut.
#
# lt_draw_arrow_menu <question> <option...>: prints one frame of the menu
# lt_arrow_menu below draws/redraws. Reads $selected as a shell dynamic-
# scope variable rather than taking it as a parameter — every caller is
# lt_arrow_menu itself, which always has `selected` set as a local right
# before calling this, and POSIX sh functions see their caller's locals
# (there's no lexical closure to fake otherwise). Split out to a top-level
# function instead of nested inside lt_arrow_menu purely so it's defined
# once, not redefined on every single lt_arrow_menu call.
lt_draw_arrow_menu() {
  local i opt
  tty_out "${_LT_CYAN}?${_LT_RESET} $1"
  shift
  i=1
  for opt in "$@"; do
    if [ "$i" -eq "$selected" ]; then
      tty_out "  ${_LT_CYAN}>${_LT_RESET} ${_LT_BOLD}$opt${_LT_RESET}"
    else
      tty_out "    ${_LT_DIM}$opt${_LT_RESET}"
    fi
    i=$((i + 1))
  done
}

# Falls back to the plain always-worked numbered prompt if raw mode isn't
# available at all (`stty -g` failing to read the tty's own attributes —
# some unusual terminal) - still fully interactive, just no arrow keys.
lt_arrow_menu() {
  local question="$1" selected="$2" n old_stty key1 key2 key3 i opt chosen j
  shift 2
  n=$#

  old_stty="$(stty -g < /dev/tty 2>/dev/null)" || {
    tty_out "$question"
    i=1
    for opt in "$@"; do
      if [ "$i" -eq "$selected" ]; then tty_out "  $i) $opt (default)"; else tty_out "  $i) $opt"; fi
      i=$((i + 1))
    done
    tty_prompt "  > "
    read -r key1 < /dev/tty || key1=""
    case "$key1" in
      [1-9]) [ "$key1" -le "$n" ] && selected="$key1" ;;
    esac
    printf '%s\n' "$selected"
    return
  }

  lt_draw_arrow_menu "$question" "$@"
  # Tracked globally so the safety-net EXIT trap (see below) can restore
  # the terminal even if this function never reaches its own restore below
  # - a signal arriving mid-read would otherwise leave the tty stuck in
  # raw/no-echo mode (invisible typing) for the rest of the session.
  _LT_RAW_STTY="$old_stty"
  stty -icanon -echo min 1 time 0 < /dev/tty

  while :; do
    key1="$(dd if=/dev/tty bs=1 count=1 2>/dev/null)"
    if [ "$key1" = "$_LT_ESC" ]; then
      key2="$(dd if=/dev/tty bs=1 count=1 2>/dev/null)"
      key3="$(dd if=/dev/tty bs=1 count=1 2>/dev/null)"
      case "$key2$key3" in
        '[A') if [ "$selected" -gt 1 ]; then selected=$((selected - 1)); else selected=$n; fi ;;
        '[B') if [ "$selected" -lt "$n" ]; then selected=$((selected + 1)); else selected=1; fi ;;
      esac
    elif [ -z "$key1" ]; then
      break   # Enter
    else
      case "$key1" in
        [1-9]) if [ "$key1" -le "$n" ]; then selected="$key1"; break; fi ;;
      esac
    fi
    printf '%s[%dA' "$_LT_ESC" "$((n + 1))" > /dev/tty
    lt_draw_arrow_menu "$question" "$@"
  done
  stty "$old_stty" < /dev/tty
  _LT_RAW_STTY=""

  # Collapse the question+options block down to one confirmed summary line.
  printf '%s[%dA' "$_LT_ESC" "$((n + 1))" > /dev/tty
  j=0
  while [ "$j" -le "$n" ]; do
    printf '%s[2K\n' "$_LT_ESC" > /dev/tty
    j=$((j + 1))
  done
  printf '%s[%dA' "$_LT_ESC" "$((n + 1))" > /dev/tty
  i=1
  chosen=""
  for opt in "$@"; do
    [ "$i" -eq "$selected" ] && chosen="$opt"
    i=$((i + 1))
  done
  tty_out "${_LT_GREEN}✔${_LT_RESET} $question ${_LT_DIM}$chosen${_LT_RESET}"

  printf '%s\n' "$selected"
}

# ask_yes_no <label> (m-10/TASK-106): arrow-key Yes/No menu. Returns success
# for yes, failure for no.
ask_yes_no() {
  [ "$(lt_arrow_menu "$1" 1 "Yes" "No")" = "1" ]
}

# ask_version <default-version> (m-10/TASK-106): arrow-key default-or-
# custom menu. Prints the chosen version. A real "pick from actually-
# installable versions" menu (`asdf list all <plugin>`) isn't reliable
# here: this script runs as phase 0, before asdf/the plugin are even
# guaranteed to exist yet (phases 1-2), and `list all` can be slow (network
# fetch) even when they do — so this stays a plain default-vs-custom
# choice, not a live version browser.
ask_version() {
  local default="$1" custom
  if [ "$(lt_arrow_menu "Version:" 1 "$default (default)" "Enter a specific version")" = "2" ]; then
    tty_prompt "  Version > "
    read -r custom < /dev/tty || custom=""
    [ -n "$custom" ] && printf '%s\n' "$custom" || printf '%s\n' "$default"
  else
    printf '%s\n' "$default"
  fi
}

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
trap 'lt_restore_raw_stty; $SUCCESS || rm -f "$OUT_FILE"' EXIT

# Non-interactive session, or the caller explicitly asked for everything:
# skip the language menu entirely and use the default config as-is. Scope
# still comes from --local if given; otherwise there's no tty to ask, so
# it defaults to global (scope_line() already does this when SCOPE="").
if ! $INTERACTIVE || $SELECT_ALL; then
  # Only announce this when it's the SILENT fallback (no tty, no --all) -
  # a caller who explicitly passed --all already knows what they asked for.
  # Without this, a CI run with no flags at all installs every language with
  # no indication that's what just happened (found during a UX pass,
  # m-6/TASK-95.1). To stderr, not tty_out - there may be no /dev/tty to
  # write to at all in this exact branch, and stdout is reserved for the
  # OUT_FILE path handoff below.
  if ! $INTERACTIVE && ! $SELECT_ALL; then
    echo "No controlling terminal detected - installing every language in $DEFAULT_CONFIG (same as --all)." >&2
  fi
  write_with_scope "$DEFAULT_CONFIG" "$OUT_FILE"
  SUCCESS=true
  echo "$OUT_FILE"   # the one line of "real" stdout output
  exit 0
fi

# Interactive path: start the selection file empty and build it up below.
: > "$OUT_FILE"

tty_out ""
tty_out "== Select languages to install (Enter = yes) =="

# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why
# (the /dev/tty reads below are already redirected per-command so they're
# safe either way, but fd 3 keeps every loop in this codebase consistent).
# `each_tool` prints "plugin version" pairs for every language in the
# default config; POSIX sh has no process substitution (`<(...)` is a
# bash/ksh/zsh extension), so this writes each_tool's output to a temp
# file first and reads that on fd 3 instead of the loop's own stdin (fd 0).
EACH_TOOL_TMP="$(mktemp)"
each_tool "$DEFAULT_CONFIG" > "$EACH_TOOL_TMP"

# Companion plugins (m-7/TASK-100, e.g. pnpm for nodejs, gradle for java —
# see lt_companion_for_plugin() in lib.sh) don't get their own top-level
# "Install X?" question here: asked alone, out of context, "Install pnpm
# (pnpm)? [Y/n]" gives no hint it's tied to nodejs. Instead they're offered
# as a follow-up right after their parent is accepted, below. Precomputed
# once here (plain stdin, not fd 3 - this small loop doesn't touch
# /dev/tty) so the main loop can skip them on sight.
ALL_COMPANIONS=""
while read -r each_plugin _each_version; do
  companion="$(lt_companion_for_plugin "$each_plugin")"
  [ -n "$companion" ] && ALL_COMPANIONS="$ALL_COMPANIONS $companion"
done < "$EACH_TOOL_TMP"

while read -r plugin default_version <&3; do
  # Companion plugin: handled as a follow-up to its parent below, not here.
  case " $ALL_COMPANIONS " in *" $plugin "*) continue ;; esac

  # Just for a friendlier prompt line, e.g. "nodejs (node)".
  cmd="$(binary_for_plugin "$plugin")"
  tty_out ""
  if ask_yes_no "Install $plugin ($cmd)?"; then
    version="$(ask_version "$default_version")"

    # Record this language/version as one line of the selection file.
    printf '%s %s\n' "$plugin" "$version" >> "$OUT_FILE"

    # Offer this language's companion(s), if it has any AND the config file
    # actually carries a default version for it (a config file with no
    # companion line - e.g. this repo's own custom TOOL_VERSIONS_FILE users
    # can pass - has nothing to offer, so silently skip rather than
    # prompting for a version with no default).
    for companion in $(lt_companion_for_plugin "$plugin"); do
      companion_default="$(awk -v p="$companion" '$1 == p { print $2; exit }' "$EACH_TOOL_TMP")"
      [ -n "$companion_default" ] || continue
      if ask_yes_no "  Also install $companion (companion to $plugin)?"; then
        companion_version="$(ask_version "$companion_default")"
        printf '%s %s\n' "$companion" "$companion_version" >> "$OUT_FILE"
      fi
    done
  fi
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"

# `-s` = file exists and is non-empty. If the user answered "n" to every
# single language, there's nothing to install — stop here instead of
# silently proceeding with an empty plan.
if [ ! -s "$OUT_FILE" ]; then
  tty_out ""
  tty_out "No languages selected. Cancelling installation."
  exit 1
fi

# Recap what was selected before asking for final confirmation.
tty_out ""
tty_out "== Install list =="
while read -r plugin version; do
  tty_out "  $plugin  $version"
done < "$OUT_FILE"
tty_out ""

# Ask where to pin these versions, unless --local[=DIR] already decided it.
if [ -z "$SCOPE" ]; then
  if [ "$(lt_arrow_menu "Pin these versions:" 1 "Globally" "Only in this directory")" = "2" ]; then
    tty_prompt "  Which directory? [default: current directory] > "
    read -r scope_dir_answer < /dev/tty || scope_dir_answer=""
    SCOPE_DIR="$(resolve_scope_dir "${scope_dir_answer:-$(pwd)}")"
    SCOPE="local"
  else
    SCOPE="global"
  fi
fi

if ! $AUTO_YES; then
  tty_out ""
  if ! ask_yes_no "Install?"; then
    tty_out "Cancelled."
    exit 1
  fi
fi

# Prepend the scope line now that it's finally settled (flag or prompt).
SCOPE_TMP="$(mktemp)"
write_with_scope "$OUT_FILE" "$SCOPE_TMP"
mv "$SCOPE_TMP" "$OUT_FILE"

# The ONLY thing written to real stdout: the path main.sh should read the
# final selection from.
SUCCESS=true
echo "$OUT_FILE"
