# shellcheck shell=bash
# Regression tests for scripts/uninstall/04_remove_system_deps.sh (also the
# file at the center of TASK-78: missing ensure_brew_on_path caused brew
# cleanup to silently no-op when brew wasn't already on this process's
# PATH). `brew` is always Mocked here - never left to resolve for real, per
# the TASK-81 lesson (PATH restriction alone isn't a safe enough guard,
# since ensure_brew_on_path re-adds Homebrew's fixed prefix regardless).
Describe 'scripts/uninstall/04_remove_system_deps.sh'
  SCRIPT='./scripts/uninstall/04_remove_system_deps.sh'

  setup() { export DRY_RUN=false; }
  BeforeEach 'setup'

  It 'uninstalls every installed LT_BUILD_DEPS formula'
    Mock brew
      case "$1 $2" in
        "list openssl") exit 0 ;;
        "list readline") exit 0 ;;
        "list sqlite3") exit 0 ;;
        "list xz") exit 0 ;;
        "list zlib") exit 0 ;;
        "list tcl-tk") exit 0 ;;
        "uninstall openssl") echo "UNINSTALLED: $2" ;;
        "uninstall readline") echo "UNINSTALLED: $2" ;;
        "uninstall sqlite3") echo "UNINSTALLED: $2" ;;
        "uninstall xz") echo "UNINSTALLED: $2" ;;
        "uninstall zlib") echo "UNINSTALLED: $2" ;;
        "uninstall tcl-tk") echo "UNINSTALLED: $2" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'UNINSTALLED: openssl'
    The output should include 'UNINSTALLED: tcl-tk'
  End

  It 'skips a formula that is not installed, without erroring'
    Mock brew
      case "$1 $2" in
        "list openssl") exit 1 ;;
        "list readline") exit 1 ;;
        "list sqlite3") exit 1 ;;
        "list xz") exit 1 ;;
        "list zlib") exit 1 ;;
        "list tcl-tk") exit 1 ;;
        uninstall*) echo "UNEXPECTED UNINSTALL: $2" ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should not include 'UNEXPECTED'
  End

  It 'treats "required by another package" as informational, not fatal'
    Mock brew
      case "$1 $2" in
        "list openssl") exit 0 ;;
        "list readline") exit 1 ;;
        "list sqlite3") exit 1 ;;
        "list xz") exit 1 ;;
        "list zlib") exit 1 ;;
        "list tcl-tk") exit 1 ;;
        "uninstall openssl") exit 1 ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should include 'Skipped openssl'
  End
End
