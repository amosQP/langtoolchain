# shellcheck shell=bash
# Regression tests for scripts/install/01_bootstrap_asdf.sh.
#
# SAFETY: `brew`/`asdf` are always Mocked in every test here, never left to
# resolve for real - this dev machine has real Homebrew and real asdf
# installed. Relying on PATH restriction alone is NOT enough (see TASK-81:
# ensure_brew_on_path() re-adds Homebrew's fixed install prefix regardless
# of what PATH already contains, once a real near-miss actually fired
# `brew uninstall asdf` against this exact machine). Mock wins the PATH
# lookup regardless, so it's what actually keeps this file safe to run.
#
# The "Homebrew/asdf is genuinely absent, so install it for real" branches
# aren't covered here. Simulating "genuinely absent" requires restricting
# PATH so `command -v` truly fails - but empirically, restricting PATH
# ahead of a `Mock` declaration in this shellspec version prevents Mock's
# own scratch-dir prepend from taking effect at all (confirmed by hand:
# `PATH=<restricted>; export PATH` before `Mock brew` left PATH as exactly
# the restricted value with no mock dir prepended, so the real system
# binaries would've been the ones actually found - not safe to rely on for
# a file that can run `brew`/`asdf` for real). Both branches are already
# covered by e2e-verify.yml's `no-homebrew-bootstrap` job (TASK-20) and the
# `full-cycle` job's very first run, on real, disposable CI hardware where
# nothing is pre-installed - a strictly safer way to exercise "not found"
# than fighting this dev machine's real installs locally.
Describe 'scripts/install/01_bootstrap_asdf.sh'
  SCRIPT='./scripts/install/01_bootstrap_asdf.sh'

  setup() { export DRY_RUN=true; }
  BeforeEach 'setup'

  It 'reports Homebrew and asdf already present without reinstalling either'
    Mock brew
      echo '/mock/bin/brew'
    End
    Mock asdf
      case "$1" in
        version) echo '0.20.0' ;;
      esac
    End
    When run "$SCRIPT"
    The output should include 'Homebrew found'
    The output should include 'asdf already installed'
    The output should not include 'brew install asdf'
  End

  It 'fails clearly on a non-macOS uname (this installer is macOS-only)'
    Mock uname
      echo 'Linux'
    End
    When run "$SCRIPT"
    The status should be failure
    The output should include 'Phase 1'
    The error should include 'only supports macOS'
  End

  Describe 'fetch_verified_homebrew_installer() curl call (TASK-131.1)'
    # A dynamic Mock-based test (calling fetch_verified_homebrew_installer()
    # directly with curl Mocked to simulate a timeout) was attempted first,
    # the same way spec/lib_spec.sh's retry() tests call a lib.sh function
    # directly. It doesn't work here: 01_bootstrap_asdf.sh locates its own
    # sibling lib.sh via `dirname "$0"`, which only resolves correctly when
    # the file is *executed* as its own process (`When run`, where the
    # shell sets $0 to the script path) - sourcing it with `.` leaves $0 as
    # shellspec's own, so SCRIPT_DIR resolves to the wrong directory and
    # lib.sh never actually loads (LT_DOWNLOAD_TIMEOUT itself is declared
    # in this file, not lib.sh, but the same sibling-source limitation
    # still applies to a `When call` test here).
    # And reaching this function through a real `When run` requires brew to
    # be genuinely absent from PATH, which - per this file's header comment
    # above - Mock can't simulate (it only adds a fake command to PATH, it
    # can't remove the real one), and restricting PATH by hand breaks
    # Mock's own prepend in this shellspec version. So this checks the
    # fetch call's source line directly instead: same intent (confirm the
    # Homebrew installer fetch has a hard timeout like every other
    # network call in this diff), a static assertion instead of a dynamic
    # one.
    It 'passes --max-time LT_DOWNLOAD_TIMEOUT to the installer'\
' fetch, like every other curl call in this file'
      fetch_line="$(grep -n 'curl -fsSL' "$SCRIPT" |
        grep 'HOMEBREW_INSTALL_URL')"
      When call echo "$fetch_line"
      The output should include '--max-time'
      The output should include 'LT_DOWNLOAD_TIMEOUT'
    End
  End
End
