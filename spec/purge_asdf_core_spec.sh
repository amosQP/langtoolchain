# shellcheck shell=bash
# Regression tests for scripts/uninstall/05_purge_asdf_core.sh (TASK-70):
# it must respect a live ASDF_DATA_DIR override, same as ensure_asdf_on_path()
# does, instead of always deleting the default $HOME/.asdf regardless of
# where asdf's data actually lives.
Describe 'scripts/uninstall/05_purge_asdf_core.sh'
  SCRIPT='./scripts/uninstall/05_purge_asdf_core.sh'

  # PATH deliberately excludes Homebrew's bin dir: this dev machine has a
  # real asdf installed via real Homebrew, and DRY_RUN=false below would
  # otherwise make `run brew uninstall asdf` execute for real. With brew
  # unreachable, `if brew list asdf ...` just evaluates false (command not
  # found) and the script moves on to the directory-deletion logic under
  # test, using ordinary /bin utilities (rm, mkdir) which stay reachable.
  setup() {
    fake_home="$(mktemp -d)"
    SAFE_PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  }
  cleanup() { rm -rf "$fake_home"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'removes the default $HOME/.asdf when ASDF_DATA_DIR is unset'
    mkdir -p "$fake_home/.asdf/shims"
    export HOME="$fake_home" DRY_RUN=false PATH="$SAFE_PATH"
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Removing'
    The path "$fake_home/.asdf" should not be exist
  End

  It 'removes the custom ASDF_DATA_DIR instead of the default (TASK-70)'
    custom_dir="$(mktemp -d)/custom-asdf-data"
    mkdir -p "$custom_dir/shims"
    mkdir -p "$fake_home/.asdf/shims"   # decoy default dir - must survive
    export HOME="$fake_home" ASDF_DATA_DIR="$custom_dir" DRY_RUN=false PATH="$SAFE_PATH"
    When run "$SCRIPT"
    The output should include 'Removing'
    The path "$custom_dir" should not be exist
    The path "$fake_home/.asdf" should be exist
    rm -rf "$(dirname "$custom_dir")"
  End

  It 'does DRY_RUN without deleting anything'
    mkdir -p "$fake_home/.asdf/shims"
    export HOME="$fake_home" DRY_RUN=true
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include '+ rm -rf'
    The path "$fake_home/.asdf" should be exist
  End
End
