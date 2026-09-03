#!/usr/bin/env sh
# Post-install checks. Deliberately no `set -e` — a test runner should
# evaluate every assertion and report all of them, not stop at the first
# failure.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
readonly REPO_ROOT
readonly CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 7: Validating installation"

# Under --dry-run nothing was actually installed, so checking real system
# state here would just report false failures — skip instead.
if [ "${DRY_RUN:-false}" = "true" ]; then
  log "(dry-run: no runtimes were actually installed, skipping validation)"
  exit 0
fi

RC_FILE="$(detect_rc_file)"
readonly RC_FILE

OK=true

# fd 3, not stdin — the `"$cmd" ... | head -n 1` pipe below would otherwise
# race this loop's own `read` over the same fd (see 02_install_plugins.sh).
# POSIX sh has no process substitution, so each_tool's output goes to a
# temp file first.
EACH_TOOL_TMP="$(mktemp)"
readonly EACH_TOOL_TMP
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"
# validate_one_tool <plugin> <version> (m-8): checks one tool's PATH
# resolution and reported version; logs FAIL/OK/WARN lines itself and
# returns failure only for the FAIL case (not-found), so the loop below can
# do `validate_one_tool ... || OK=false` instead of carrying the full
# per-tool check inline.
validate_one_tool() {
  local plugin="$1" version="$2" cmd flag resolved_path version_line expected_core
  # e.g. "nodejs" -> "node", so we know which command to actually check.
  cmd="$(binary_for_plugin "$plugin")"
  # e.g. "node" -> "-v", the flag that prints that command's version.
  flag="$(flag_for_binary "$cmd")"

  # Where does the shell actually find this command right now?
  # `|| true` turns "not found" into an empty string instead of an error.
  resolved_path="$(command -v "$cmd" 2>/dev/null || true)"
  if [ -z "$resolved_path" ]; then
    log "  FAIL: '$cmd' not found in PATH."
    return 1
  fi
  case "$resolved_path" in
    # Resolving through an asdf shim is the success case — it means asdf,
    # not some other system-wide install, is what PATH will actually run.
    # Compared against $ASDF_DATA_DIR (set by ensure_asdf_on_path above),
    # not a hardcoded ".asdf", so a custom ASDF_DATA_DIR doesn't false-WARN.
    "$ASDF_DATA_DIR/shims/"*) log "  OK:   $cmd -> $resolved_path" ;;
    # WARN, not FAIL, is a deliberate policy (TASK-117.5 reevaluation,
    # decision-3) - not a bug being left unfixed. A same-named binary
    # earlier on PATH is extremely common and usually benign (system
    # tools, a Homebrew formula installed for reasons unrelated to this
    # installer, etc.), so hard-failing an otherwise-successful install
    # over it would produce far more false-positive failures than real
    # catches. It's still worth surfacing clearly, though: this is the one
    # "shim security" checkpoint this repo actually owns (see
    # docs/download-points-inventory.md #9) - whatever this installer just
    # verified/pinned (TASK-117.1/117.2) doesn't cover $cmd once something
    # else is what actually runs when you type it.
    *) log "  WARN: $cmd resolves outside asdf shims ($resolved_path) — something earlier on PATH is shadowing it; the binary that actually runs isn't the one this installer set up, and isn't covered by anything this installer verifies" ;;
  esac

  # Some tools (java) print their version to stderr, hence 2>&1. First line
  # containing a digit, not just the first line (m-7/TASK-101) - gradle's
  # `--version` banner opens with a bare "----..." separator line before
  # "Gradle 9.4.1", so a plain `head -n 1` would grab the separator instead
  # of the version. Every version string this tool already compares against
  # (node/java/python/rustc/go) already puts its version on line 1 too, so
  # this is behavior-identical for all of them - not gradle-specific.
  version_line="$("$cmd" "$flag" 2>&1 | grep -m 1 '[0-9]')"
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
  return 0
}

while read -r plugin version <&3; do
  validate_one_tool "$plugin" "$version" || OK=false
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"

log ""
log "If there are any FAIL/WARN items above: run 'source $RC_FILE' (or open a new terminal) and check again."

# Mirrors 06_validate_teardown.sh's OK-tracking exit: a FAIL here means a
# tool a phase claimed to install isn't actually usable, so a CI/wrapper
# script checking this phase's exit code must be able to tell — logging
# alone let a broken install report success before this.
if $OK; then
  exit 0
else
  exit 1
fi
