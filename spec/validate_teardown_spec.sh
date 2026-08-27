# shellcheck shell=bash
# Regression tests for scripts/uninstall/06_validate_teardown.sh (TASK-65),
# the uninstall-side counterpart of the 07_validate.sh fix from TASK-57: the
# PATH/JAVA_HOME checks must judge against $ASDF_DATA_DIR, not a hardcoded
# ".asdf" literal, or a custom ASDF_DATA_DIR user gets a false FAIL/misses a
# real leftover. See spec/validate_spec.sh for the install-side sibling.
Describe 'scripts/uninstall/06_validate_teardown.sh'
  SCRIPT='./scripts/uninstall/06_validate_teardown.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir"
    # A PATH with nothing asdf-related on it — the "cleanly torn down" case.
    clean_path="/usr/bin:/bin:/usr/sbin:/sbin"
  }
  cleanup() {
    rm -rf "$(dirname "$data_dir")"
  }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  Describe 'PATH check (custom ASDF_DATA_DIR)'
    It 'reports OK when a clean PATH holds no leftover shims for a custom ASDF_DATA_DIR'
      export ASDF_DATA_DIR="$data_dir" PATH="$clean_path" DRY_RUN=false
      unset -v JAVA_HOME
      When run "$SCRIPT"
      The output should include 'OK:   PATH has no asdf shims.'
      The output should not include 'FAIL'
    End

    It 'reports FAIL when the custom ASDF_DATA_DIR shims path is still on PATH'
      export ASDF_DATA_DIR="$data_dir" PATH="$data_dir/shims:$clean_path" DRY_RUN=false
      unset -v JAVA_HOME
      When run "$SCRIPT"
      The output should include 'FAIL: $ASDF_DATA_DIR/shims is still in this session'"'"'s PATH.'
      The status should be failure
    End
  End

  Describe 'JAVA_HOME check (custom ASDF_DATA_DIR)'
    It 'reports OK when JAVA_HOME does not point into the custom ASDF_DATA_DIR'
      export ASDF_DATA_DIR="$data_dir" PATH="$clean_path" JAVA_HOME="/usr/lib/jvm/system-java" DRY_RUN=false
      When run "$SCRIPT"
      The output should include 'OK:   JAVA_HOME not pointing at asdf.'
    End

    It 'reports FAIL when JAVA_HOME still points into the custom ASDF_DATA_DIR'
      export ASDF_DATA_DIR="$data_dir" PATH="$clean_path" JAVA_HOME="$data_dir/installs/java/21.0.0" DRY_RUN=false
      When run "$SCRIPT"
      The output should include 'FAIL: $JAVA_HOME still points into $ASDF_DATA_DIR.'
      The status should be failure
    End
  End

  Describe 'DRY_RUN=true'
    It 'skips all validation instead of reporting false failures'
      export ASDF_DATA_DIR="$data_dir" PATH="$data_dir/shims:$clean_path" DRY_RUN=true
      When run "$SCRIPT"
      The output should include '(dry-run: nothing was actually removed, skipping validation)'
      The output should not include 'FAIL'
      The status should be success
    End
  End
End
