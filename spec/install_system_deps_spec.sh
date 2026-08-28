# shellcheck shell=bash
# Regression tests for scripts/install/03_install_system_deps.sh.
# `brew` is always Mocked - see spec/bootstrap_asdf_spec.sh for why PATH
# restriction alone isn't a safe enough guard on its own (TASK-81).
Describe 'scripts/install/03_install_system_deps.sh'
  SCRIPT='./scripts/install/03_install_system_deps.sh'

  It 'installs the full LT_BUILD_DEPS list in one brew call'
    export DRY_RUN=false
    Mock brew
      case "$1" in
        install) echo "MOCK: brew install $*" ;;
        *) echo '/mock/bin/brew' ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'MOCK: brew install install openssl readline sqlite3 xz zlib tcl-tk'
  End

  It 'only previews under DRY_RUN, never calling brew for real'
    export DRY_RUN=true
    Mock brew
      echo 'UNEXPECTED: brew was actually invoked'
    End
    When run "$SCRIPT"
    The output should include '+ brew install openssl readline sqlite3 xz zlib tcl-tk'
    The output should not include 'UNEXPECTED'
  End
End
