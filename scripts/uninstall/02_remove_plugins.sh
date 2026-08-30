#!/usr/bin/env sh
# Removes every installed asdf plugin (not just this repo's own languages —
# see below), ahead of asdf itself being purged in phase 5.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

step "Phase 2: Removing asdf plugins"

# Removes EVERY installed plugin, not just the ones this repo's
# .tool-versions lists — asdf is being uninstalled entirely in phase 5, so
# leftover plugins from other tools would just become orphaned directories
# under ~/.asdf/plugins with no asdf left to manage them.
#
# fd 3, not stdin — see scripts/install/02_install_plugins.sh for why.
# POSIX sh has no process substitution, so this goes to a temp file first.
PLUGIN_LIST_TMP="$(mktemp)"
asdf plugin list 2>/dev/null > "$PLUGIN_LIST_TMP" || true
# `|| [ -n "$plugin" ]`: unlike each_tool()/lt_env_var_defs() (our own
# printf-based output, always newline-terminated), this file comes from an
# external command we don't control the exact output of — `read` returns
# failure at EOF, and without this guard a final line with no trailing
# newline would be silently dropped even though `read` did populate it.
while read -r plugin <&3 || [ -n "$plugin" ]; do
  [ -n "$plugin" ] || continue   # skip a stray blank line, if any
  log "Removing plugin: $plugin"
  if run asdf plugin remove "$plugin"; then
    lt_report removed "asdf plugin: $plugin"
  fi
done 3< "$PLUGIN_LIST_TMP"
rm -f "$PLUGIN_LIST_TMP"
