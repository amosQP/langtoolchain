#!/usr/bin/env sh
# The slow part: compiles/installs each selected language runtime via asdf.
# Ensures asdf/shims + build flags itself instead of trusting phase 04's rc
# file edits to already be sourced into this process.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
# `asdf install` needs `asdf` itself on PATH ...
ensure_asdf_on_path
# ... and Python specifically needs these to find OpenSSL/SQLite/zlib
# while compiling — phase 04 wrote them into the rc file for *future*
# shells, but this process needs them right now.
ensure_build_flags

REPO_ROOT="$(repo_root_from "$0")"
readonly REPO_ROOT
readonly CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 5: Installing language runtimes (this can take a while)"

# fd 3, not stdin — see 02_install_plugins.sh for why. POSIX sh has no
# process substitution, so each_tool's output goes to a temp file first.
# FAILED (TASK-89): collects languages that failed to install instead of
# dying immediately on the first one, so one bad build doesn't stop every
# OTHER selected language from even being attempted — mirrors
# uninstall/01_uninstall_runtimes.sh's own `|| true` per-item pattern.
# Checked once after the loop: if anything failed, this phase itself must
# still fail (die() below) rather than let 06_set_globals.sh go on to
# `asdf set` a version that was never actually installed.
FAILED=""
EACH_TOOL_TMP="$(mktemp)"
readonly EACH_TOOL_TMP
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"
while read -r plugin version <&3; do
  log "Installing $plugin $version ..."
  # This is the actual compile/download step — by far the slowest part of
  # the whole installer. `run` still respects --dry-run. retry (TASK-88):
  # this is the single most network/time-intensive step in the whole
  # installer, so it's the one most worth retrying automatically.
  if retry 3 5 run asdf install "$plugin" "$version"; then
    lt_report installed "$plugin $version (asdf)"
  else
    log "  FAILED: $plugin $version (continuing with remaining languages)"
    FAILED="${FAILED}${FAILED:+, }$plugin $version"
  fi
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"

[ -z "$FAILED" ] || die "One or more runtimes failed to install: $FAILED. Re-run to retry just the missing ones (asdf skips what's already installed)."
