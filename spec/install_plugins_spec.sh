# shellcheck shell=bash
# Regression test for scripts/install/02_install_plugins.sh's exact-match
# plugin-presence check (`grep -qx`) - guards against a plugin named e.g.
# "python" being mistaken for already-installed just because a
# differently-named plugin like "python-build" happens to share the prefix.
Describe 'scripts/install/02_install_plugins.sh'
  SCRIPT='./scripts/install/02_install_plugins.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir/shims"
    tool_versions="$(mktemp)"
    printf 'python 3.12.13\n' > "$tool_versions"
    # LT_REPORT_FILE: without this, DRY_RUN=false below means the script's
    # own lt_report() calls default to $HOME/.langtoolchain-report.log -
    # the REAL one, since this spec doesn't override HOME. Redirect to a
    # scratch file so running this test suite doesn't pollute it.
    report_file="$(mktemp)"
    export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" \
      DRY_RUN=false LT_REPORT_FILE="$report_file"
  }
  cleanup() { rm -rf "$(dirname "$data_dir")" "$tool_versions" "$report_file"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  Describe 'plugin already installed'
    It 'recognizes an exact-name match and does not re-add it'
      Mock asdf
        case "$1 $2" in
          "plugin update") exit 0 ;;
          "plugin list") printf 'python\n' ;;
          "plugin add") echo "UNEXPECTED ADD: $3" ;;
        esac
      End
      When run "$SCRIPT"
      The output should include 'Plugin already present: python'
      The output should not include 'UNEXPECTED ADD'
    End
  End

  Describe 'plugin not installed (prefix false-positive guard)'
    It 'does not mistake "python-build" for an installed "python" plugin'
      Mock asdf
        case "$1 $2" in
          "plugin update") exit 0 ;;
          "plugin list") printf 'python-build\n' ;;
          "plugin add") echo "ADDED: $3" ;;
        esac
      End
      When run "$SCRIPT"
      The output should include 'Adding plugin: python'
      The output should include 'ADDED: python'
      The output should not include 'Plugin already present: python'
    End
  End

  Describe 'no plugins installed yet'
    It 'adds the plugin when `asdf plugin list` is empty (fresh asdf install)'
      Mock asdf
        case "$1 $2" in
          "plugin update") exit 0 ;;
          "plugin list") : ;;
          "plugin add") echo "ADDED: $3" ;;
        esac
      End
      When run "$SCRIPT"
      The output should include 'ADDED: python'
    End
  End

  Describe 'partial failure isolation (TASK-89)'
    It 'still attempts every plugin even after one fails, then fails overall'
      printf 'nodejs lts\npython 3.12.13\n' > "$tool_versions"
      # sleep Mocked so retry()'s backoff between nodejs's 3 failing
      # attempts doesn't actually wait in this test.
      Mock sleep
        :
      End
      Mock asdf
        case "$1 $2" in
          "plugin update") exit 0 ;;
          "plugin list") : ;;
          "plugin add")
            case "$3" in
              nodejs) exit 1 ;;
              python) echo "ADDED: $3" ;;
            esac
            ;;
        esac
      End
      When run "$SCRIPT"
      The status should be failure
      The output should include 'ADDED: python'
      The error should include 'Failed to add plugin(s): nodejs'
    End
  End
End
