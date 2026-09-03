# shellcheck shell=bash
# Regression tests for scripts/uninstall/02_remove_plugins.sh - removes
# EVERY installed asdf plugin this tool is responsible for (not just this
# repo's own 5 languages), the TASK-77 trailing-newline fix for `asdf
# plugin list`'s output, and (TASK-130) skips any plugin the install-time
# snapshot says pre-existed langtoolchain, same safety guarantee
# 05_purge_asdf_core.sh already has for the asdf data dir.
# `asdf` is always Mocked, not left to resolve for real.
Describe 'scripts/uninstall/02_remove_plugins.sh'
  SCRIPT='./scripts/uninstall/02_remove_plugins.sh'

  setup() {
    # LT_REPORT_FILE: redirect away from the real $HOME/.langtoolchain-
    # report.log - this spec doesn't override HOME, and DRY_RUN=false here
    # means lt_report() would otherwise write there for real.
    report_file="$(mktemp)"
    # LT_PRIOR_STATE_FILE: isolated from the real $HOME/.langtoolchain-
    # prior-asdf-state (this dev machine may well have one, e.g. from
    # earlier purge_asdf_core_spec.sh runs) - defaults every example below
    # to an explicit "nothing pre-existed" snapshot, matching this file's
    # pre-TASK-130 behavior (remove every plugin unconditionally). Examples
    # that actually test the TASK-130 prior-state logic overwrite this
    # file's content themselves.
    prior_state_file="$(mktemp)"
    printf 'asdf_plugins_preexisting=\n' > "$prior_state_file"
    export DRY_RUN=false LT_REPORT_FILE="$report_file" LT_PRIOR_STATE_FILE="$prior_state_file"
  }
  cleanup() { rm -f "$report_file" "$prior_state_file"; }
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

  It 'skips a pre-existing plugin but removes a newly-installed one (TASK-130, mixed)'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\npython\n' ;;
        "plugin remove") echo "REMOVED: $3" ;;
      esac
    End
    printf 'asdf_plugins_preexisting=nodejs\n' > "$prior_state_file"
    When run "$SCRIPT"
    The output should include 'Skipping plugin (existed before langtoolchain): nodejs'
    The output should not include 'REMOVED: nodejs'
    The output should include 'REMOVED: python'
  End

  It 'skips every plugin when the prior-state snapshot file is entirely missing (TASK-130, safe default)'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\npython\n' ;;
        "plugin remove") echo "REMOVED: $3" ;;
      esac
    End
    rm -f "$prior_state_file"   # simulates install before this feature existed, or --dry-run
    When run "$SCRIPT"
    The output should include 'Skipping plugin (existed before langtoolchain): nodejs'
    The output should include 'Skipping plugin (existed before langtoolchain): python'
    The output should not include 'REMOVED:'
  End

  It 'skips every plugin when the snapshot exists but has no asdf_plugins_preexisting key (TASK-130, safe default)'
    Mock asdf
      case "$1 $2" in
        "plugin list") printf 'nodejs\n' ;;
        "plugin remove") echo "REMOVED: $3" ;;
      esac
    End
    printf 'asdf_preexisting=false\n' > "$prior_state_file"   # no plugins key
    When run "$SCRIPT"
    The output should include 'Skipping plugin (existed before langtoolchain): nodejs'
    The output should not include 'REMOVED:'
  End
End
