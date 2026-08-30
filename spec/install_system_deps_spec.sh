# shellcheck shell=bash
# Regression tests for scripts/install/03_install_system_deps.sh.
# `brew` is always Mocked - see spec/bootstrap_asdf_spec.sh for why PATH
# restriction alone isn't a safe enough guard on its own (TASK-81).
Describe 'scripts/install/03_install_system_deps.sh'
  SCRIPT='./scripts/install/03_install_system_deps.sh'

  It 'installs the full LT_BUILD_DEPS list in one brew call'
    # LT_REPORT_FILE: redirect away from the real $HOME/.langtoolchain-
    # report.log - this spec doesn't override HOME, and DRY_RUN=false here
    # means lt_report() would otherwise write there for real.
    report_file="$(mktemp)"
    export DRY_RUN=false LT_REPORT_FILE="$report_file"
    Mock brew
      case "$1" in
        install) echo "MOCK: brew install $*" ;;
        *) echo '/mock/bin/brew' ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'MOCK: brew install install openssl readline sqlite3 xz zlib tcl-tk'
    rm -f "$report_file"
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
