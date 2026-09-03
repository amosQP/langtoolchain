#!/usr/bin/env sh
# Removes asdf itself and its data directory. Only ever touches the user's
# *global* ~/.tool-versions — never this repo's own .tool-versions, which is
# a tracked project file, not machine state.
#
# The data-dir deletion below (TASK-124/decision-6) is conditional on the
# install-time snapshot from TASK-123: it never removes a data dir that
# looks like it pre-dates this tool. The `brew uninstall asdf` and
# ~/.tool-versions removal above/below it are NOT gated the same way —
# TASK-124.1's own scope is specifically "the rm -rf $TARGET_ASDF_DATA_DIR
# block", not a general "leave everything alone if asdf pre-existed" pass.
set -eu
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"
# Same reasoning as every brew-touching install phase (see lib.sh): this
# runs as its own process, so `brew` moments-old on PATH in some other
# phase's process isn't guaranteed to be on THIS one's PATH too.
ensure_brew_on_path

step "Phase 5: Removing asdf core"

if brew list asdf >/dev/null 2>&1; then
  log "Uninstalling asdf (Homebrew) ..."
  if run brew uninstall asdf; then
    lt_report removed "asdf (Homebrew)"
  fi
fi

# Respect a live ASDF_DATA_DIR override (same fallback ensure_asdf_on_path()
# uses, via lt_asdf_data_dir()) instead of always assuming the default — a
# user who installed with a custom ASDF_DATA_DIR would otherwise have their
# real data directory silently left behind (TASK-70).
TARGET_ASDF_DATA_DIR="$(lt_asdf_data_dir)"

if [ -d "$TARGET_ASDF_DATA_DIR" ]; then
  # This is where EVERYTHING asdf-managed actually lives: downloads,
  # installs, plugins, and shims all sit under here. Removing it deletes
  # every compiled runtime this tool ever installed — but ALSO anything
  # that was already sitting there before this tool ever ran, if this
  # machine had asdf set up beforehand (m-13/TASK-124). lt_prior_state_get
  # reads the snapshot install wrote before touching anything (TASK-123);
  # only an explicit "false" (this dir did NOT exist pre-install) clears
  # this for deletion.
  #
  # Safe-by-default for every other case (TASK-124.1 AC #2): a MISSING
  # snapshot — installed before this feature existed, or installed via
  # --dry-run, which never writes one — is indistinguishable here from
  # "don't know", so it's treated the same as "true" (pre-existing) rather
  # than assumed safe to wipe.
  if [ "$(lt_prior_state_get asdf_data_dir_preexisting || true)" = "false" ]; then
    log "Removing $TARGET_ASDF_DATA_DIR ..."
    run rm -rf "$TARGET_ASDF_DATA_DIR"
    lt_report removed "$TARGET_ASDF_DATA_DIR (entire asdf data dir: installs, plugins, shims)"
  else
    log "Skipping $TARGET_ASDF_DATA_DIR — it looks like it existed before langtoolchain was installed (or that can't be confirmed from a missing snapshot), so it's being left in place rather than risk deleting asdf state this tool didn't create. If you're sure it's safe, remove it yourself: rm -rf \"$TARGET_ASDF_DATA_DIR\""
    lt_report skipped "$TARGET_ASDF_DATA_DIR (looked pre-existing, or unconfirmed — not removed; see README)"
  fi
fi

if [ -f "$HOME/.tool-versions" ]; then
  # Deliberately $HOME/.tool-versions (the machine-wide default asdf falls
  # back to) — NOT $REPO_ROOT/.tool-versions, which is a file tracked in
  # this git repo and not something an uninstaller should ever delete.
  log "Removing $HOME/.tool-versions ..."
  run rm -f "$HOME/.tool-versions"
  lt_report removed "$HOME/.tool-versions"
fi

# m-16/TASK-139/decision-8: this is the last phase (main.sh's phase list ends
# here), and the only reader of LT_PRIOR_STATE_FILE is the "true"-vs-"false"
# check above (TASK-124.1) — nothing later in this run reads it again. So
# once every command above this line has succeeded (set -eu killed the
# script already if any of them failed), the snapshot has done its job for
# THIS uninstall and can be cleared, letting the next install re-baseline
# from the machine's actual post-uninstall state instead of staying pinned
# to whatever this machine looked like the very first time langtoolchain
# ever snapshotted it. Guarded the same way
# lt_snapshot_prior_asdf_state() (scripts/lib.sh) guards its own write:
# DRY_RUN never touched real state, so it must not delete the snapshot
# either. A failed/interrupted uninstall (this phase or an earlier one)
# never reaches this line, so decision-6's original concern — a retry
# needing the snapshot still there — is unaffected.
[ "$DRY_RUN" = "true" ] || rm -f "$LT_PRIOR_STATE_FILE"
