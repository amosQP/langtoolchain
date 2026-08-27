#!/usr/bin/env sh
# Adds the asdf plugin for each selected language. Ensures asdf/shims are on
# PATH itself — does not rely on phase 01 having exported anything into
# this process, since main.sh runs every phase as its own child process.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
# See lib.sh: exports ASDF_DATA_DIR and prepends its shims dir to PATH for
# THIS process, since nothing upstream is guaranteed to have done it yet.
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "$0")"
# TOOL_VERSIONS_FILE is set by main.sh to whatever 00_select.sh produced
# (the user's picks); fall back to the repo's own .tool-versions when this
# script is run standalone, outside the normal orchestrated flow.
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[ -f "$CONFIG_FILE" ] || die "Config file not found: $CONFIG_FILE"

step "Phase 2: Installing asdf plugins"

# Refresh every already-installed plugin's own git checkout. `|| true`:
# a stale/unreachable plugin repo shouldn't abort the whole install.
run asdf plugin update --all || true

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
EACH_TOOL_TMP="$(mktemp)"
each_tool "$CONFIG_FILE" > "$EACH_TOOL_TMP"
while read -r plugin version <&3; do
  # -x: exact whole-line match, so "python" doesn't accidentally match a
  # plugin named e.g. "python-build".
  if printf '%s\n' "$existing_plugins" | grep -qx "$plugin"; then
    log "Plugin already present: $plugin"
  else
    log "Adding plugin: $plugin"
    run asdf plugin add "$plugin"
  fi
done 3< "$EACH_TOOL_TMP"
rm -f "$EACH_TOOL_TMP"
