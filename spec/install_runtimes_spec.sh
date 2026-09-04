# shellcheck shell=bash
# Regression tests for scripts/install/05_install_runtimes.sh's partial
# failure isolation (TASK-89): one language failing to install must not
# stop the others from being attempted, and a failure must still make the
# phase itself fail overall (so 06_set_globals.sh never runs `asdf set` on
# a version that was never actually installed).
Describe 'scripts/install/05_install_runtimes.sh'
  SCRIPT='./scripts/install/05_install_runtimes.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir/shims"
    tool_versions="$(mktemp)"
    # LT_REPORT_FILE: redirect away from the real $HOME/.langtoolchain-
    # report.log (this spec doesn't override HOME, and DRY_RUN=false below
    # means lt_report() would otherwise write there for real).
    report_file="$(mktemp)"
    export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" \
      DRY_RUN=false LT_REPORT_FILE="$report_file"
  }
  cleanup() { rm -rf "$(dirname "$data_dir")" "$tool_versions" "$report_file"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'installs every language when none fail'
    printf 'nodejs lts\npython 3.12.13\n' > "$tool_versions"
    Mock asdf
      case "$1 $2 $3" in
        "install nodejs lts") echo "INSTALLED: $2 $3" ;;
        "install python 3.12.13") echo "INSTALLED: $2 $3" ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should include 'INSTALLED: nodejs lts'
    The output should include 'INSTALLED: python 3.12.13'
  End

  It 'still attempts every language after one fails, then fails overall'
    printf 'nodejs lts\npython 3.12.13\ngolang 1.26.1\n' > "$tool_versions"
    # sleep Mocked so retry()'s backoff between python's 3 failing attempts
    # doesn't actually wait in this test.
    Mock sleep
      :
    End
    Mock asdf
      case "$1 $2 $3" in
        "install nodejs lts") echo "INSTALLED: $2 $3" ;;
        "install python 3.12.13") exit 1 ;;
        "install golang 1.26.1") echo "INSTALLED: $2 $3" ;;
      esac
    End
    When run "$SCRIPT"
    The status should be failure
    The output should include 'INSTALLED: nodejs lts'
    The output should include 'INSTALLED: golang 1.26.1'
    The error should include 'One or more runtimes failed to install:'\
' python 3.12.13'
    # TASK-151/decision-12: a recurring failure may mean the asdf plugin
    # doesn't support that version yet, not a transient network blip -
    # point the user at the actual escape hatch instead of just "re-run".
    The error should include 'asdf list all <plugin>'
  End

  It 'retries a transient failure and succeeds without ever reporting'\
' it as failed'
    Mock sleep
      :
    End
    # Mock blocks run as separate child processes - a plain shell variable
    # set here wouldn't be visible inside them, so this needs `export`.
    attempt_file="$(mktemp)"
    export attempt_file
    printf '0' > "$attempt_file"
    printf 'python 3.12.13\n' > "$tool_versions"
    Mock asdf
      case "$1 $2 $3" in
        "install python 3.12.13")
          n="$(cat "$attempt_file")"
          n=$((n + 1))
          printf '%s' "$n" > "$attempt_file"
          if [ "$n" -lt 2 ]; then
            exit 1
          fi
          echo "INSTALLED: $2 $3"
          ;;
      esac
    End
    When run "$SCRIPT"
    The status should be success
    The output should include 'INSTALLED: python 3.12.13'
    rm -f "$attempt_file"
  End
End
