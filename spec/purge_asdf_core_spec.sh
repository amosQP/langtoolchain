# shellcheck shell=bash
# Regression tests for scripts/uninstall/05_purge_asdf_core.sh (TASK-70):
# it must respect a live ASDF_DATA_DIR override, same as ensure_asdf_on_path()
# does, instead of always deleting the default $HOME/.asdf regardless of
# where asdf's data actually lives.
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
  }
  cleanup() { rm -rf "$fake_home"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'removes the default $HOME/.asdf when ASDF_DATA_DIR is unset'
    Mock brew
      case "$1 $2" in
        "list asdf") exit 0 ;;
        "uninstall asdf") echo "MOCK: brew uninstall asdf" ;;
      esac
    End
    mkdir -p "$fake_home/.asdf/shims"
    export HOME="$fake_home" DRY_RUN=false
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include 'Removing'
    The output should include 'MOCK: brew uninstall asdf'
    The path "$fake_home/.asdf" should not be exist
  End

  It 'removes the custom ASDF_DATA_DIR instead of the default (TASK-70)'
    Mock brew
      case "$1 $2" in
        "list asdf") exit 0 ;;
        "uninstall asdf") echo "MOCK: brew uninstall asdf" ;;
      esac
    End
    custom_dir="$(mktemp -d)/custom-asdf-data"
    mkdir -p "$custom_dir/shims"
    mkdir -p "$fake_home/.asdf/shims"   # decoy default dir - must survive
    export HOME="$fake_home" ASDF_DATA_DIR="$custom_dir" DRY_RUN=false
    When run "$SCRIPT"
    The output should include 'Removing'
    The path "$custom_dir" should not be exist
    The path "$fake_home/.asdf" should be exist
    rm -rf "$(dirname "$custom_dir")"
  End

  It 'does DRY_RUN without deleting anything'
    Mock brew
      case "$1 $2" in
        "list asdf") exit 0 ;;
        "uninstall asdf") echo "MOCK: brew uninstall asdf" ;;
      esac
    End
    mkdir -p "$fake_home/.asdf/shims"
    export HOME="$fake_home" DRY_RUN=true
    unset -v ASDF_DATA_DIR
    When run "$SCRIPT"
    The output should include '+ rm -rf'
    The path "$fake_home/.asdf" should be exist
  End
End
