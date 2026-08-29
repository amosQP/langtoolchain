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
  tty_prompt "Install $plugin ($cmd)? [Y/n] > "
  # Read the answer straight from the terminal device, not this loop's fd
  # 3/fd 0 — `|| answer=""` treats Ctrl-D / a closed tty as "no answer" so
  # the script degrades gracefully instead of erroring under `set -e`.
  read -r answer < /dev/tty || answer=""
  case "$answer" in
    n|N|no|NO) continue ;;   # skip this language entirely; move to the next
  esac

  tty_prompt "  Version [default: $default_version] > "
  read -r version < /dev/tty || version=""
  # Empty input (plain Enter) means "use the default version".
  [ -n "$version" ] || version="$default_version"

  # Record this language/version as one line of the selection file.
  printf '%s %s\n' "$plugin" "$version" >> "$OUT_FILE"

  # Offer this language's companion(s), if it has any AND the config file
  # actually carries a default version for it (a config file with no
  # companion line - e.g. this repo's own custom TOOL_VERSIONS_FILE users
  # can pass - has nothing to offer, so silently skip rather than prompting
  # for a version with no default).
  for companion in $(lt_companion_for_plugin "$plugin"); do
    companion_default="$(awk -v p="$companion" '$1 == p { print $2; exit }' "$EACH_TOOL_TMP")"
    [ -n "$companion_default" ] || continue
    tty_prompt "  Also install $companion (companion to $plugin)? [Y/n] > "
    read -r companion_answer < /dev/tty || companion_answer=""
    case "$companion_answer" in
      n|N|no|NO) continue ;;
    esac
    tty_prompt "    Version [default: $companion_default] > "
    read -r companion_version < /dev/tty || companion_version=""
    [ -n "$companion_version" ] || companion_version="$companion_default"
    printf '%s %s\n' "$companion" "$companion_version" >> "$OUT_FILE"
  done
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
  tty_prompt "Pin globally, or only in this directory? [global/local, default: global] > "
  read -r scope_answer < /dev/tty || scope_answer=""
  case "$scope_answer" in
    local|Local|l|L)
      tty_prompt "  Which directory? [default: current directory] > "
      read -r scope_dir_answer < /dev/tty || scope_dir_answer=""
      SCOPE_DIR="$(resolve_scope_dir "${scope_dir_answer:-$(pwd)}")"
      SCOPE="local"
      ;;
    *)
      SCOPE="global"
      ;;
  esac
fi

if ! $AUTO_YES; then
  tty_prompt "Install? [Y/n] > "
  read -r confirm < /dev/tty || confirm=""
  case "$confirm" in
    n|N|no|NO) tty_out "Cancelled."; exit 1 ;;
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
