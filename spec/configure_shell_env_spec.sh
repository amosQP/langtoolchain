# shellcheck shell=bash
# Regression tests for scripts/install/04_configure_shell_env.sh:
# - PATH ordering: the "eval $(brew shellenv)" line must stay ahead of the
#   asdf shim PATH line in the rc file, or a same-named Homebrew formula
#   silently shadows the asdf-managed version. This exact bug was found and
#   fixed on real hardware once already (commit f19057d) - this test exists
#   so it can't silently come back.
# - Idempotency: re-running the installer against an rc file that already
#   has these lines must not duplicate them.
Describe 'scripts/install/04_configure_shell_env.sh'
  SCRIPT='./scripts/install/04_configure_shell_env.sh'

  setup() {
    fake_home="$(mktemp -d)"
    export HOME="$fake_home" SHELL=/bin/zsh DRY_RUN=false
  }
  cleanup() { rm -rf "$fake_home"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'writes the brew shellenv line ahead of the asdf shim PATH line'
    When run "$SCRIPT"
    The output should include 'Phase 4'
    rc_file="$fake_home/.zshrc"
    brew_line="$(grep -n 'brew shellenv' "$rc_file" | head -n1 | cut -d: -f1)"
    shim_line="$(grep -n 'ASDF_DATA_DIR/shims' "$rc_file" | head -n1 | cut -d: -f1)"
    The variable brew_line should be present
    The variable shim_line should be present
    order_ok=false
    [ "$brew_line" -lt "$shim_line" ] && order_ok=true
    The variable order_ok should eq 'true'
  End

  It 'does not duplicate any line when run twice (idempotent re-install)'
    "$SCRIPT" > /dev/null
    rc_file="$fake_home/.zshrc"
    first_run_line_count="$(wc -l < "$rc_file")"
    When run "$SCRIPT"
    The output should include 'Phase 4'
    second_run_line_count="$(wc -l < "$rc_file")"
    The variable first_run_line_count should eq "$second_run_line_count"
    dup_count="$(grep -c 'ASDF_DATA_DIR/shims' "$rc_file")"
    The variable dup_count should eq 1
  End

  It 'creates the rc file if it does not exist yet (brand-new machine)'
    rc_file="$fake_home/.zshrc"
    not_yet=false
    [ -e "$rc_file" ] || not_yet=true
    When run "$SCRIPT"
    The output should include 'Phase 4'
    The variable not_yet should eq 'true'
    The path "$rc_file" should be exist
  End
End
