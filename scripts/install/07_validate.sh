#!/usr/bin/env bash
# Post-install checks. Deliberately no `set -e` — a test runner should
# evaluate every assertion and report all of them, not stop at the first
# failure.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 7: Validating installation"

if [[ "${DRY_RUN:-false}" == "true" ]]; then
  log "(dry-run: no runtimes were actually installed, skipping validation)"
  exit 0
fi

RC_FILE="$(detect_rc_file)"

# fd 3, not stdin — the `"$cmd" ... | head -n 1` pipe below would otherwise
# race this loop's own `read` over the same fd (see 02_install_plugins.sh).
while read -r plugin version <&3; do
  cmd="$(binary_for_plugin "$plugin")"
  flag="$(flag_for_binary "$cmd")"

  resolved_path="$(command -v "$cmd" 2>/dev/null || true)"
  if [[ -z "$resolved_path" ]]; then
    log "  FAIL: '$cmd' not found in PATH."
    continue
  fi
  case "$resolved_path" in
    *".asdf/shims/"*) log "  OK:   $cmd -> $resolved_path" ;;
    *) log "  WARN: $cmd resolves outside asdf shims ($resolved_path)" ;;
  esac

  version_line="$("$cmd" $flag 2>&1 | head -n 1)"
  log "        $version_line"
done 3< <(each_tool "$CONFIG_FILE")

log ""
log "FAIL/WARN 항목이 있다면: 'source $RC_FILE' (또는 새 터미널) 실행 후 다시 확인하세요."
