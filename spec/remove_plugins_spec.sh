# shellcheck shell=bash
# Regression tests for scripts/uninstall/02_remove_plugins.sh - removes
# EVERY installed asdf plugin (not just this repo's own 5 languages),
# and the TASK-77 trailing-newline fix for `asdf plugin list`'s output.
# `asdf` is always Mocked, not left to resolve for real.
Describe 'scripts/uninstall/02_remove_plugins.sh'
  SCRIPT='./scripts/uninstall/02_remove_plugins.sh'

  setup() {
    # LT_REPORT_FILE: redirect away from the real $HOME/.langtoolchain-
    # report.log - this spec doesn't override HOME, and DRY_RUN=false here
    # means lt_report() would otherwise write there for real.
    report_file="$(mktemp)"
    export DRY_RUN=false LT_REPORT_FILE="$report_file"
  }
  cleanup() { rm -f "$report_file"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'removes every plugin asdf plugin list reports, not just this repo languages'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\nsome-other-tool\n' ;;
        "plugin remove") echo "REMOVED: $3" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'REMOVED: nodejs'
    The output should include 'REMOVED: some-other-tool'
  End

  It 'still removes the last plugin when asdf plugin list has no trailing newline (TASK-77)'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\npython' ;;   # deliberately no trailing \n
        "plugin remove") echo "REMOVED: $3" ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'REMOVED: nodejs'
    The output should include 'REMOVED: python'
  End

  It 'does not fail the whole script when one plugin remove fails'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\npython\n' ;;
        "plugin remove")
          case "$3" in
            nodejs) exit 1 ;;
            python) echo "REMOVED: $3" ;;
          esac
          ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should include 'REMOVED: python'
  End

  It 'handles an empty plugin list without error (fresh asdf install)'
    Mock asdf
      case "$1 $2" in
        "plugin list") : ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should include 'Phase 2'
  End
End
