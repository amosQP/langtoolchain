#!/usr/bin/env sh
# Adds the asdf plugin for each selected language. Ensures asdf/shims are on
# PATH itself — does not rely on phase 01 having exported anything into
# this process, since main.sh runs every phase as its own child process.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR
. "$SCRIPT_DIR/../lib.sh"
# See lib.sh: exports ASDF_DATA_DIR and prepends its shims dir to PATH for
# THIS process, since nothing upstream is guaranteed to have done it yet.
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
readonly REPO_ROOT
# TOOL_VERSIONS_FILE is set by main.sh to whatever 00_select.sh produced
# (the user's picks); fall back to the repo's own .tool-versions when this
# script is run standalone, outside the normal orchestrated flow.
readonly CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 2: Installing asdf plugins"

# LT_PLUGIN_TIMEOUT (TASK-145.4): wall-clock timeout, in seconds, for each
# `asdf plugin add`/`asdf plugin update --all` call below. Both shell out
# to `git clone`/`git fetch` internally with no timeout of their own -
# exposed to the same DNS/TCP/TLS-handshake blackhole
# lt_run_with_timeout() (TASK-138.1) exists to close, and without it a
# single stuck plugin repo would hang forever instead of letting retry
# (TASK-88) actually get its intended extra attempts. Its own budget, not
# LT_VERSION_FETCH_TIMEOUT (lib.sh, tuned for a few hundred bytes of
# JSON) - a plugin's git clone is a much bigger call. Override-able like
# LT_VERSION_FETCH_TIMEOUT, so not readonly.
LT_PLUGIN_TIMEOUT="${LT_PLUGIN_TIMEOUT:-30}"

# Refresh every already-installed plugin's own git checkout. retry
# (TASK-88): worth a couple of attempts before giving up on a network blip.
# `|| true`: a stale/unreachable plugin repo shouldn't abort the whole
# install even after retries are exhausted.
retry 3 5 run lt_run_with_timeout "$LT_PLUGIN_TIMEOUT" \
  asdf plugin update --all || true

# Capture once, up front, instead of piping straight into `grep -q` inside
# the loop: grep -q closes the pipe as soon as it matches, which can
# SIGPIPE `asdf` mid-write and make the pipeline report failure even
# though grep found what it was looking for — intermittently misreporting
# an installed plugin as missing. A plain variable has no pipe to race.
# (`|| true`: an empty plugin list, e.g. right after installing asdf for
# the first time, is not an error.)
existing_plugins="$(asdf plugin list 2>/dev/null || true)"

# fd 3, not stdin: keeps this loop's own `read` isolated from anything a
# future edit to the loop body might do with stdin. POSIX sh has no
# process substitution, so each_tool's output goes to a temp file first.
# FAILED (TASK-89): collects plugins that failed to add instead of dying
# immediately on the first one — mirrors uninstall/02_remove_plugins.sh's
# own `|| true` per-item pattern, so one unreachable plugin repo doesn't
# stop every OTHER selected language from even being attempted. Checked
# once after the loop, not per-iteration, so every language gets a shot
# before this script decides whether to fail overall.
FAILED=""
EACH_TOOL_TMP="$(mktemp)"
readonly EACH_TOOL_TMP
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"
while read -r plugin version <&3; do
  # -x: exact whole-line match, so "python" doesn't accidentally match a
  # plugin named e.g. "python-build".
  if printf '%s\n' "$existing_plugins" | grep -qx "$plugin"; then
    log "Plugin already present: $plugin"
  else
    log "Adding plugin: $plugin"
    if retry 3 5 run lt_run_with_timeout "$LT_PLUGIN_TIMEOUT" \
      asdf plugin add "$plugin"; then
      lt_report installed "asdf plugin: $plugin"
    else
      log "  FAILED: $plugin (continuing with remaining languages)"
      FAILED="${FAILED}${FAILED:+ }$plugin"
    fi
  fi
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"

[ -z "$FAILED" ] || die "Failed to add plugin(s): $FAILED"
