# shellcheck shell=bash
# Regression tests for scripts/install/main.sh and scripts/uninstall/
# main.sh - previously untested (see git history: no main_spec.sh ever
# existed). Most of what these orchestrators do (acquire_lock -> 00_select.sh
# -> run_phase over real asdf/brew-touching phases) can't be exercised
# locally without a real asdf/Homebrew stack, per this repo's own
# test-safety convention (see e.g. bootstrap_asdf_spec.sh's header comment).
#
# The unknown-flag rejection path is the one exception: it's reached right
# after acquire_lock (LT_LOCK_DIR overridden below to a scratch dir, so this
# never touches the real shared lock) and exits before anything else runs -
# no 00_select.sh, no phases, no brew/asdf. Entered via the root install.sh/
# uninstall.sh entry points (not scripts/install/main.sh directly), so this
# also exercises install.sh's/uninstall.sh's own "local clone detected ->
# exec straight into main.sh" dispatch, itself never directly tested before.
Describe 'install.sh -> scripts/install/main.sh (flag validation)'
  SCRIPT='./install.sh'

  setup() {
    lock_dir="$(mktemp -d)/lt-test.lock"
    export LT_LOCK_DIR="$lock_dir"
  }
  cleanup() { rm -rf "$(dirname "$lock_dir")"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'rejects an unknown flag with a clear message and exits 1'
    When run "$SCRIPT" --bogus-flag
    The status should be failure
    The error should include 'Unknown option: --bogus-flag'
  End

  It 'releases the lock even when rejecting an unknown flag (EXIT'\
' trap still fires)'
    "$SCRIPT" --bogus-flag 2>/dev/null || true
    When call true
    The path "$lock_dir" should not be exist
  End
End

Describe 'uninstall.sh -> scripts/uninstall/main.sh (flag validation)'
  SCRIPT='./uninstall.sh'

  setup() {
    lock_dir="$(mktemp -d)/lt-test.lock"
    export LT_LOCK_DIR="$lock_dir"
  }
  cleanup() { rm -rf "$(dirname "$lock_dir")"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'rejects an unknown flag with a clear message and exits 1'
    When run "$SCRIPT" --bogus-flag
    The status should be failure
    The error should include 'Unknown option: --bogus-flag'
  End

  It 'releases the lock even when rejecting an unknown flag (EXIT'\
' trap still fires)'
    "$SCRIPT" --bogus-flag 2>/dev/null || true
    When call true
    The path "$lock_dir" should not be exist
  End
End
