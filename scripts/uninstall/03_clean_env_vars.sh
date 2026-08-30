#!/usr/bin/env sh
# Strips every line this tool's install phase (04_configure_shell_env.sh)
# may have added, from whichever rc files exist. Sweeps lib.sh's
# LT_KNOWN_RC_FILES (TASK-66) — all rc files this tool ever knows how to
# write into, not just the one detect_rc_file() would pick right now —
# since the install may have happened under a different shell than the one
# running uninstall.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 3: Cleaning shell environment variables"

for rc_name in $LT_KNOWN_RC_FILES; do
  rc="$HOME/$rc_name"
  [ -f "$rc" ] || continue   # nothing to clean if this rc file doesn't exist
  log "Cleaning $rc ..."
  if [ "$DRY_RUN" = "true" ]; then
    log "  + remove asdf/build-flag lines (sed -i.bak) from $rc"
    continue
  fi
  # macOS's BSD sed requires an explicit (even if empty) backup suffix
  # argument to -i; '.bak' also means we never destructively edit the rc
  # file without a recovery copy sitting right next to it.
  #
  # -E (extended regex): earlier versions of this script alternated
  # `\(zsh\|bash\)` for the java hook line, which is silently NOT
  # alternation on BSD sed (macOS's stock /usr/bin/sed) without -E — `\|`
  # is a GNU extension to POSIX basic regex. lt_env_var_defs()'s single
  # "set-java-home\." pattern below sidesteps that entirely (it matches
  # either variant without needing alternation), but -E is kept since nothing
  # here depends on BRE-specific behavior either.
  #
  # Each search pattern comes from lib.sh's lt_env_var_defs() (TASK-64) —
  # the same list install/04_configure_shell_env.sh writes from — instead
  # of an independently-typed copy here. `\#pattern#d` (not `/pattern/d`):
  # some patterns (e.g. "opt/sqlite/bin") contain literal `/`, and a custom
  # sed delimiter avoids having to escape those.
  #
  # POSIX sh has neither arrays nor process substitution. lt_env_var_defs()
  # goes to a temp file first; the -e/expression pairs accumulate one per
  # line in SED_ARGS (not space-joined) so a pattern containing a literal
  # space (e.g. "brew shellenv") still becomes exactly one sed argument —
  # `set --` below re-splits only on the newlines, never on the spaces
  # inside a line.
  ENV_DEFS_TMP="$(mktemp)"
  lt_env_var_defs > "$ENV_DEFS_TMP"
  SED_ARGS=""
  while IFS= read -r def; do
    pattern="${def%%|||*}"
    SED_ARGS="${SED_ARGS}-e
\\#${pattern}#d
"
  done < "$ENV_DEFS_TMP"
  rm -f "$ENV_DEFS_TMP"
  IFS="
"
  # shellcheck disable=SC2086
  set -- $SED_ARGS
  unset IFS
  sed -E -i '.bak' "$@" "$rc"
  log "  Backup preserved at ${rc}.bak"
  lt_report modified "$rc (removed asdf/build-flag lines, backup: ${rc}.bak)"
done
