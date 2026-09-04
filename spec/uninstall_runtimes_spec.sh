# shellcheck shell=bash
# Regression tests for scripts/uninstall/01_uninstall_runtimes.sh's
# local-pins read side (TASK-83): a runtime version only ever pinned inside
# a project directory (never in the global ~/.tool-versions) never shows up
# in the global config this script reads by default, so without reading
# $ASDF_DATA_DIR/langtoolchain-local-pins too, it would silently survive
# uninstall. See spec/set_globals_spec.sh for the write side.
Describe 'scripts/uninstall/01_uninstall_runtimes.sh'
  SCRIPT='./scripts/uninstall/01_uninstall_runtimes.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir/shims"
    fake_home="$(mktemp -d)"
    pin_dir="$(mktemp -d)"
    export ASDF_DATA_DIR="$data_dir" HOME="$fake_home" DRY_RUN=false
    unset -v TOOL_VERSIONS_FILE
    pins_file="$data_dir/langtoolchain-local-pins"
  }
  cleanup() { rm -rf "$(dirname "$data_dir")" "$fake_home" "$pin_dir"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'uninstalls a version only ever pinned locally, listed only'\
' in the pins file'
    # No global ~/.tool-versions at all - the ONLY record of this plugin
    # existing is the local pin below, exactly the case this closes. Points
    # away from this repo's own real .tool-versions, which CONFIG_FILE would
    # otherwise fall all the way back to.
    export TOOL_VERSIONS_FILE="$pin_dir/does-not-exist"
    printf '%s\n' "$pin_dir" > "$pins_file"
    printf 'python 3.12.13\n' > "$pin_dir/.tool-versions"
    Mock asdf
      case "$1 $2 $3" in
        "list python 3.12.13") exit 0 ;;
        "uninstall python 3.12.13") echo "UNINSTALLED: $2 $3" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'Uninstalling local pins from'
    The output should include 'UNINSTALLED: python 3.12.13'
  End

  It 'skips a pinned directory that no longer has a .tool-versions file'
    # No global config at all here (this test is only about the local-pins
    # loop), so point TOOL_VERSIONS_FILE at a path that doesn't exist rather
    # than let CONFIG_FILE fall all the way back to this repo's own real
    # .tool-versions.
    export TOOL_VERSIONS_FILE="$pin_dir/does-not-exist"
    printf '%s\n' "$pin_dir" > "$pins_file"
    # Deliberately no .tool-versions written into $pin_dir.
    Mock asdf
      echo "UNEXPECTED CALL: $*"
    End
    When run "$SCRIPT"
    The output should not include 'UNEXPECTED CALL'
  End

  It 'processes both the global config and local pins in the same run'
    printf 'nodejs lts\n' > "$fake_home/.tool-versions"
    printf '%s\n' "$pin_dir" > "$pins_file"
    printf 'python 3.12.13\n' > "$pin_dir/.tool-versions"
    Mock asdf
      case "$1 $2 $3" in
        "list nodejs lts") exit 0 ;;
        "uninstall nodejs lts") echo "UNINSTALLED: $2 $3" ;;
        "list python 3.12.13") exit 0 ;;
        "uninstall python 3.12.13") echo "UNINSTALLED: $2 $3" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'UNINSTALLED: nodejs lts'
    The output should include 'UNINSTALLED: python 3.12.13'
  End

  It 'does nothing extra when no local-pins file exists'
    printf 'nodejs lts\n' > "$fake_home/.tool-versions"
    Mock asdf
      case "$1 $2 $3" in
        "list nodejs lts") exit 0 ;;
        "uninstall nodejs lts") echo "UNINSTALLED: $2 $3" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'UNINSTALLED: nodejs lts'
    The status should be success
  End
End
