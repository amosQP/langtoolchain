#!/usr/bin/env sh
# Post-install checks. Deliberately no `set -e` — a test runner should
# evaluate every assertion and report all of them, not stop at the first
# failure.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 7: Validating installation"

# Under --dry-run nothing was actually installed, so checking real system
# state here would just report false failures — skip instead.
if [ "${DRY_RUN:-false}" = "true" ]; then
  log "(dry-run: no runtimes were actually installed, skipping validation)"
  exit 0
fi

RC_FILE="$(detect_rc_file)"

# fd 3, not stdin — the `"$cmd" ... | head -n 1` pipe below would otherwise
# race this loop's own `read` over the same fd (see 02_install_plugins.sh).
# POSIX sh has no process substitution, so each_tool's output goes to a
# temp file first.
EACH_TOOL_TMP="$(mktemp)"
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"
while read -r plugin version <&3; do
  # e.g. "nodejs" -> "node", so we know which command to actually check.
  cmd="$(binary_for_plugin "$plugin")"
  # e.g. "node" -> "-v", the flag that prints that command's version.
  flag="$(flag_for_binary "$cmd")"

  # Where does the shell actually find this command right now?
  # `|| true` turns "not found" into an empty string instead of an error.
  resolved_path="$(command -v "$cmd" 2>/dev/null || true)"
  if [ -z "$resolved_path" ]; then
    log "  FAIL: '$cmd' not found in PATH."
    continue
  fi
  case "$resolved_path" in
    # Resolving through an asdf shim is the success case — it means asdf,
    # not some other system-wide install, is what PATH will actually run.
    # Compared against $ASDF_DATA_DIR (set by ensure_asdf_on_path above),
    # not a hardcoded ".asdf", so a custom ASDF_DATA_DIR doesn't false-WARN.
    "$ASDF_DATA_DIR/shims/"*) log "  OK:   $cmd -> $resolved_path" ;;
    *) log "  WARN: $cmd resolves outside asdf shims ($resolved_path)" ;;
  esac

  # Some tools (java) print their version to stderr, hence 2>&1; `head -n 1`
  # keeps the log to one line even for multi-line version banners.
  version_line="$("$cmd" "$flag" 2>&1 | head -n 1)"
  # Compare against the version requested in .tool-versions. Aliases like
  # "lts" have no numeric core, so version_core is empty and we skip the
  # check rather than false-warn.
  expected_core="$(version_core "$version")"
  # POSIX [ ] has no glob-pattern matching ([[ != *pat* ]]'s job), so a
  # case statement does the "does version_line contain expected_core"
  # check instead.
  if [ -n "$expected_core" ]; then
    case "$version_line" in
      *"$expected_core"*) log "        $version_line" ;;
      *) log "  WARN: $cmd reports '$version_line', expected version matching '$version'" ;;
    esac
  else
    log "        $version_line"
  fi
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"

log ""
log "FAIL/WARN 항목이 있다면: 'source $RC_FILE' (또는 새 터미널) 실행 후 다시 확인하세요."
