#!/usr/bin/env bash
# Adds the asdf plugin for each selected language. Ensures asdf/shims are on
# PATH itself — does not rely on phase 01 having exported anything into
# this process, since main.sh runs every phase as its own child process.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

REPO_ROOT="$(repo_root_from "${BASH_SOURCE[0]}")"
CONFIG_FILE="${TOOL_VERSIONS_FILE:-$REPO_ROOT/.tool-versions}"
[[ -f "$CONFIG_FILE" ]] || die "Config file not found: $CONFIG_FILE"

step "Phase 2: Installing asdf plugins"

run asdf plugin update --all || true

# Capture once, up front, instead of piping straight into `grep -q` inside
# the loop: under `set -o pipefail`, grep closes the pipe as soon as it
# matches, which can SIGPIPE `asdf` mid-write and make the pipeline report
# failure even though grep found what it was looking for — intermittently
# misreporting an installed plugin as missing. A plain variable has no pipe
# to race.
existing_plugins="$(asdf plugin list 2>/dev/null || true)"

# fd 3, not stdin: keeps this loop's own `read` isolated from anything a
# future edit to the loop body might do with stdin.
while read -r plugin version <&3; do
  if printf '%s\n' "$existing_plugins" | grep -qx "$plugin"; then
    log "Plugin already present: $plugin"
  else
    log "Adding plugin: $plugin"
    run asdf plugin add "$plugin"
  fi
done 3< <(each_tool "$CONFIG_FILE")
