# shellcheck shell=bash
# Regression tests for scripts/uninstall/05_purge_asdf_core.sh:
# - TASK-70: must respect a live ASDF_DATA_DIR override, same as
#   ensure_asdf_on_path() does, instead of always deleting the default
#   $HOME/.asdf regardless of where asdf's data actually lives.
# - m-13/TASK-124/decision-6: must NOT blindly rm -rf the asdf data dir if
#   the install-time snapshot (TASK-123) says it existed before
#   langtoolchain ever ran, or if that snapshot is missing entirely (safe
#   default: skip + warn, never "assume safe to delete").
Describe 'scripts/uninstall/05_purge_asdf_core.sh'
  SCRIPT='./scripts/uninstall/05_purge_asdf_core.sh'

  # `brew` is always Mocked below, never left to resolve for real - this dev
  # machine has a real asdf installed via real Homebrew, and DRY_RUN=false
  # below would otherwise make `run brew uninstall asdf` execute for real.
  # A PATH restriction alone is NOT enough to prevent that: the script now
  # calls ensure_brew_on_path() (TASK-78), which re-adds Homebrew's fixed
  # install prefix (e.g. /opt/homebrew/bin) unconditionally, regardless of
  # what PATH already contains - an earlier version of this file relied on
  # PATH restriction only, and a real `brew uninstall asdf` slipped through
  # against this actual dev machine once TASK-78 started calling
  # ensure_brew_on_path() here. Mock is what actually shadows `brew`
  # regardless of PATH tricks, since it wins by being resolved first.
  setup() {
    fake_home="$(mktemp -d)"
    # Isolated from the real $HOME/.langtoolchain-prior-asdf-state (this
    # dev machine may well have one) - every example below sets this
    # explicitly to a snapshot state it actually intends to test, instead
    # of accidentally inheriting whatever real prior-state file exists.
    LT_PRIOR_STATE_FILE="$fake_home/.langtoolchain-prior-asdf-state"
  }
  cleanup() { rm -rf "$fake_home"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  # Hoisted (TASK-134): identical across every example below - each one
  # only cares that `brew list asdf`/`brew uninstall asdf` are shadowed, not
  # about per-example variation.
  Mock brew
    case "$1 $2" in
      "list asdf") exit 0 ;;
      "uninstall asdf") echo "MOCK: brew uninstall asdf" ;;
    esac
  End

  It 'removes the default $HOME/.asdf when the snapshot says it did NOT pre-exist'
    mkdir -p "$fake_home/.asdf/shims"
    printf 'asdf_data_dir_preexisting=false\n' > "$LT_PRIOR_STATE_FILE"
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Removing'
    The output should include 'MOCK: brew uninstall asdf'
    The path "$fake_home/.asdf" should not be exist
  End

  It 'removes the custom ASDF_DATA_DIR instead of the default (TASK-70), snapshot says not pre-existing'
    custom_dir="$(mktemp -d)/custom-asdf-data"
    mkdir -p "$custom_dir/shims"
    mkdir -p "$fake_home/.asdf/shims"   # decoy default dir - must survive
    printf 'asdf_data_dir_preexisting=false\n' > "$LT_PRIOR_STATE_FILE"
    export HOME="$fake_home" ASDF_DATA_DIR="$custom_dir" DRY_RUN=false
    When run "$SCRIPT"
    The output should include 'Removing'
    The path "$custom_dir" should not be exist
    The path "$fake_home/.asdf" should be exist
    rm -rf "$(dirname "$custom_dir")"
  End

  It 'does DRY_RUN without deleting anything'
    mkdir -p "$fake_home/.asdf/shims"
    printf 'asdf_data_dir_preexisting=false\n' > "$LT_PRIOR_STATE_FILE"
    export HOME="$fake_home" DRY_RUN=true
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include '+ rm -rf'
    The path "$fake_home/.asdf" should be exist
  End

  It 'skips the data dir when the snapshot says it pre-existed langtoolchain (TASK-124.1 AC #1)'
    mkdir -p "$fake_home/.asdf/shims"
    printf 'asdf_data_dir_preexisting=true\n' > "$LT_PRIOR_STATE_FILE"
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Skipping'
    The path "$fake_home/.asdf" should be exist
  End

  It 'skips the data dir when the snapshot file is entirely missing (TASK-124.1 AC #2, safe default)'
    mkdir -p "$fake_home/.asdf/shims"
    # No LT_PRIOR_STATE_FILE written at all - simulates a machine that
    # installed before this feature existed, or via --dry-run (which never
    # writes one).
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Skipping'
    The path "$fake_home/.asdf" should be exist
  End

  It 'skips the data dir when the snapshot exists but has no asdf_data_dir_preexisting key (safe default)'
    mkdir -p "$fake_home/.asdf/shims"
    printf 'asdf_preexisting=false\n' > "$LT_PRIOR_STATE_FILE"   # no data-dir key
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Skipping'
    The path "$fake_home/.asdf" should be exist
  End

  It 'still uninstalls the asdf Homebrew formula even when the data dir is skipped (scope: only the rm -rf block is gated)'
    mkdir -p "$fake_home/.asdf/shims"
    printf 'asdf_data_dir_preexisting=true\n' > "$LT_PRIOR_STATE_FILE"
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'MOCK: brew uninstall asdf'
  End
End
