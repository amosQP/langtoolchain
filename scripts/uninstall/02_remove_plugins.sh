#!/usr/bin/env sh
# Removes every installed asdf plugin that langtoolchain itself is
# responsible for (not just this repo's own languages — see below), ahead
# of asdf itself being purged in phase 5. A plugin that already existed on
# this machine BEFORE langtoolchain ever ran is left in place instead
# (m-13/TASK-124's safety guarantee, extended here by TASK-130: this phase
# runs before 05_purge_asdf_core.sh, so if it deleted pre-existing plugins
# unconditionally, phase 5's own prior-state check for the data dir would
# already be too late — the plugins/versions it was trying to protect would
# be gone by the time phase 5 runs).
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
ensure_asdf_on_path

step "Phase 2: Removing asdf plugins"

# asdf_plugins_preexisting (m-13/TASK-123, decision-6) is a space-separated
# list of plugin names the install-time snapshot saw BEFORE langtoolchain
# touched anything — see lib.sh's lt_snapshot_prior_asdf_state. Read once,
# up front: same lt_prior_state_get() helper 05_purge_asdf_core.sh already
# uses, not a new lib.sh function — this list is only ever consulted here,
# at this one call site, so an inline case-pattern word match below is
# simpler than adding a helper for a single caller (TASK-130.1).
#
# A failed lookup (snapshot file missing entirely, or missing this key) is
# the same "installed before this feature existed, or via --dry-run" case
# phase 5 treats as unknown → safe default: every plugin is treated as if
# it pre-existed, so uninstall touches none of them rather than guess.
have_prior_state=true
preexisting_plugins=""
if snapshot_plugins="$(lt_prior_state_get asdf_plugins_preexisting)"; then
  preexisting_plugins="$snapshot_plugins"
else
  have_prior_state=false
fi

# Removes EVERY installed plugin this tool is responsible for, not just the
# ones this repo's .tool-versions lists — asdf is being uninstalled
# entirely in phase 5, so leftover plugins from other tools langtoolchain
# itself installed would just become orphaned directories under
# ~/.asdf/plugins with no asdf left to manage them. Plugins that pre-date
# langtoolchain are skipped (see above), same as phase 5's data dir.
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

  is_preexisting=false
  if [ "$have_prior_state" = "false" ]; then
    is_preexisting=true
  else
    # Padded on both sides so the pattern only matches whole words in the
    # space-separated list — e.g. "node" must not match inside "nodejs".
    case " $preexisting_plugins " in
      *" $plugin "*) is_preexisting=true ;;
    esac
  fi

  if [ "$is_preexisting" = "true" ]; then
    log "Skipping plugin (existed before langtoolchain): $plugin"
    lt_report skipped "asdf plugin: $plugin (looked pre-existing, or unconfirmed — not removed; see README)"
    continue
  fi

  log "Removing plugin: $plugin"
  if run asdf plugin remove "$plugin"; then
    lt_report removed "asdf plugin: $plugin"
  fi
done 3< "$PLUGIN_LIST_TMP"
rm -f "$PLUGIN_LIST_TMP"
