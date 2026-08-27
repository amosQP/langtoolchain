# shellcheck shell=bash
# Regression tests for scripts/uninstall/03_clean_env_vars.sh (TASK-64):
# every line 04_configure_shell_env.sh writes must be removable by this
# script's sed patterns, since both now derive from lib.sh's shared
# lt_env_var_defs() instead of two independently-typed pattern lists. This
# is exactly the bug class TASK-56 was (java hook line surviving uninstall
# because uninstall's own copy of the pattern didn't match) - a full
# install-then-uninstall round trip is the most direct way to catch it
# recurring.
Describe 'scripts/uninstall/03_clean_env_vars.sh'
  INSTALL_SCRIPT='./scripts/install/04_configure_shell_env.sh'
  CLEAN_SCRIPT='./scripts/uninstall/03_clean_env_vars.sh'

  setup() {
    fake_home="$(mktemp -d)"
  }
  cleanup() { rm -rf "$fake_home"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'removes every line the install phase wrote, leaving the rc file empty'
    HOME="$fake_home" SHELL=/bin/zsh DRY_RUN=false "$INSTALL_SCRIPT" > /dev/null
    rc_file="$fake_home/.zshrc"
    written_lines=$(( $(wc -l < "$rc_file") ))

    export HOME="$fake_home" DRY_RUN=false
    When run "$CLEAN_SCRIPT"
    The output should include 'Cleaning'
    The variable written_lines should not eq 0
    remaining=$(( $(wc -l < "$rc_file") ))
    The variable remaining should eq 0
  End

  It 'is idempotent - cleaning an already-clean rc file is a no-op'
    HOME="$fake_home" SHELL=/bin/zsh DRY_RUN=false "$INSTALL_SCRIPT" > /dev/null
    rc_file="$fake_home/.zshrc"
    HOME="$fake_home" DRY_RUN=false "$CLEAN_SCRIPT" > /dev/null
    export HOME="$fake_home" DRY_RUN=false
    When run "$CLEAN_SCRIPT"
    The output should include 'Cleaning'
    The status should be success
    remaining=$(( $(wc -l < "$rc_file") ))
    The variable remaining should eq 0
  End

  It 'leaves unrelated pre-existing rc file content untouched'
    mkdir -p "$fake_home"
    printf 'export MY_OWN_TOOL_PATH="/some/other/tool"\n' > "$fake_home/.zshrc"
    HOME="$fake_home" SHELL=/bin/zsh DRY_RUN=false "$INSTALL_SCRIPT" > /dev/null
    export HOME="$fake_home" DRY_RUN=false
    When run "$CLEAN_SCRIPT"
    The output should include 'Cleaning'
    The contents of file "$fake_home/.zshrc" should include 'MY_OWN_TOOL_PATH'
    The contents of file "$fake_home/.zshrc" should not include 'ASDF_DATA_DIR'
  End

  It 'skips DRY_RUN without modifying the rc file'
    HOME="$fake_home" SHELL=/bin/zsh DRY_RUN=false "$INSTALL_SCRIPT" > /dev/null
    rc_file="$fake_home/.zshrc"
    before="$(cat "$rc_file")"
    export HOME="$fake_home" DRY_RUN=true
    When run "$CLEAN_SCRIPT"
    The output should include 'remove asdf/build-flag lines'
    after="$(cat "$rc_file")"
    The variable after should eq "$before"
  End
End
