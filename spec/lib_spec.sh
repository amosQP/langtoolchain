# shellcheck shell=bash
# Unit tests for scripts/lib.sh - the pure-function utilities every
# install/uninstall phase script sources. No mocking needed here: these
# functions do not shell out (except run(), tested with a real no-op
# command), so failures here mean a real logic regression, not an
# environment quirk.
Describe 'scripts/lib.sh'
  Include scripts/lib.sh

  Describe 'version_core()'
    It 'extracts X.Y.Z out of an asdf vendor-version string (TASK-53)'
      When call version_core 'temurin-25.0.2+10.0.LTS'
      The output should eq '25.0.2'
    End

    It 'extracts a bare X.Y.Z version unchanged'
      When call version_core '1.94.0'
      The output should eq '1.94.0'
    End

    It 'extracts an X.Y version with no patch number'
      When call version_core '1.26'
      The output should eq '1.26'
    End

    It 'takes the first version-shaped substring when more than one exists'
      When call version_core 'go1.26.1 (built with go1.25.0)'
      The output should eq '1.26.1'
    End

    It 'prints nothing and fails for a non-numeric alias like "lts"'
      When call version_core 'lts'
      The output should eq ''
      The status should be failure
    End

    It 'prints nothing and fails for "system"'
      When call version_core 'system'
      The output should eq ''
      The status should be failure
    End
  End

  Describe 'binary_for_plugin()'
    It 'maps nodejs -> node'
      When call binary_for_plugin nodejs
      The output should eq 'node'
    End

    It 'maps java -> java'
      When call binary_for_plugin java
      The output should eq 'java'
    End

    It 'maps python -> python'
      When call binary_for_plugin python
      The output should eq 'python'
    End

    It 'maps rust -> rustc'
      When call binary_for_plugin rust
      The output should eq 'rustc'
    End

    It 'maps golang -> go'
      When call binary_for_plugin golang
      The output should eq 'go'
    End

    It 'falls back to the plugin name itself for an unknown plugin'
      When call binary_for_plugin some-custom-plugin
      The output should eq 'some-custom-plugin'
    End
  End

  Describe 'flag_for_binary()'
    It 'uses -v for node'
      When call flag_for_binary node
      The output should eq '-v'
    End

    It 'uses -version for java'
      When call flag_for_binary java
      The output should eq '-version'
    End

    It 'uses --version for python'
      When call flag_for_binary python
      The output should eq '--version'
    End

    It 'uses --version for rustc'
      When call flag_for_binary rustc
      The output should eq '--version'
    End

    It 'uses version (no dash) for go'
      When call flag_for_binary go
      The output should eq 'version'
    End

    It 'guesses --version for an unknown binary'
      When call flag_for_binary some-unknown-tool
      The output should eq '--version'
    End
  End

  Describe 'each_tool()'
    setup() {
      tool_versions="$(mktemp)"
      cat > "$tool_versions" <<'EOF'
# a leading comment should be skipped
nodejs lts


java temurin-25.0.2+10.0.LTS
python 3.12.13
EOF
    }
    cleanup() { rm -f "$tool_versions"; }
    BeforeEach 'setup'
    AfterEach 'cleanup'

    It 'skips comment and blank lines, printing only "plugin version" pairs'
      When call each_tool "$tool_versions"
      The output should eq "$(printf 'nodejs lts\njava temurin-25.0.2+10.0.LTS\npython 3.12.13')"
    End
  End

  Describe 'detect_rc_file()'
    It 'picks .zshrc for zsh'
      export SHELL=/bin/zsh
      When call detect_rc_file
      The output should eq "$HOME/.zshrc"
    End

    It 'picks .bash_profile for bash (macOS Terminal runs login shells)'
      export SHELL=/bin/bash
      When call detect_rc_file
      The output should eq "$HOME/.bash_profile"
    End

    It 'defaults to .zshrc for an unrecognized login shell'
      export SHELL=/usr/local/bin/fish
      When call detect_rc_file
      The output should eq "$HOME/.zshrc"
    End
  End

  Describe 'read_scope()'
    It 'defaults to "global" when the file has no scope comment'
      config="$(mktemp)"
      printf 'nodejs lts\n' > "$config"
      When call read_scope "$config"
      The output should eq 'global'
      rm -f "$config"
    End

    It 'reports "local:<dir>" when a scope comment is present'
      config="$(mktemp)"
      printf '# scope: local /Users/example/project\nnodejs lts\n' > "$config"
      When call read_scope "$config"
      The output should eq 'local:/Users/example/project'
      rm -f "$config"
    End
  End

  Describe 'append_env_var()'
    setup() { rc_file="$(mktemp)"; }
    cleanup() { rm -f "$rc_file"; }
    BeforeEach 'setup'
    AfterEach 'cleanup'

    It 'appends the line when the search pattern is not already present'
      When call append_env_var "$rc_file" 'ASDF_DATA_DIR' 'export ASDF_DATA_DIR="$HOME/.asdf"'
      The contents of file "$rc_file" should include 'export ASDF_DATA_DIR="$HOME/.asdf"'
    End

    It 'does not duplicate the line on a second call (idempotent re-runs)'
      append_env_var "$rc_file" 'ASDF_DATA_DIR' 'export ASDF_DATA_DIR="$HOME/.asdf"'
      When call append_env_var "$rc_file" 'ASDF_DATA_DIR' 'export ASDF_DATA_DIR="$HOME/.asdf"'
      count="$(grep -c 'ASDF_DATA_DIR' "$rc_file")"
      The variable count should eq 1
    End
  End

  Describe 'prepend_env_var()'
    setup() { rc_file="$(mktemp)"; printf 'existing line\n' > "$rc_file"; }
    cleanup() { rm -f "$rc_file"; }
    BeforeEach 'setup'
    AfterEach 'cleanup'

    It 'inserts the new line ahead of the file''s existing content'
      When call prepend_env_var "$rc_file" 'brew shellenv' 'eval "$(/opt/homebrew/bin/brew shellenv)"'
      The line 1 of contents of file "$rc_file" should include 'brew shellenv'
      The line 2 of contents of file "$rc_file" should eq 'existing line'
    End

    It 'does not duplicate the line on a second call (idempotent re-runs)'
      prepend_env_var "$rc_file" 'brew shellenv' 'eval "$(/opt/homebrew/bin/brew shellenv)"'
      When call prepend_env_var "$rc_file" 'brew shellenv' 'eval "$(/opt/homebrew/bin/brew shellenv)"'
      count="$(grep -c 'brew shellenv' "$rc_file")"
      The variable count should eq 1
    End
  End

  Describe 'ensure_asdf_on_path()'
    It 'defaults ASDF_DATA_DIR to $HOME/.asdf when unset'
      unset ASDF_DATA_DIR
      When call ensure_asdf_on_path
      The variable ASDF_DATA_DIR should eq "$HOME/.asdf"
    End

    It 'respects an already-exported custom ASDF_DATA_DIR (TASK-57)'
      export ASDF_DATA_DIR=/tmp/custom-asdf-data
      When call ensure_asdf_on_path
      The variable ASDF_DATA_DIR should eq '/tmp/custom-asdf-data'
      The variable PATH should include '/tmp/custom-asdf-data/shims:'
    End

    It 'does not add a duplicate shims entry if PATH already has it'
      export ASDF_DATA_DIR=/tmp/custom-asdf-data
      export PATH="/tmp/custom-asdf-data/shims:$PATH"
      before="$PATH"
      When call ensure_asdf_on_path
      The variable PATH should eq "$before"
    End
  End

  Describe 'ensure_brew_on_path()'
    It 'is a no-op when brew is already resolvable on PATH'
      Mock brew
        echo mock-brew
      End
      before="$PATH"
      When call ensure_brew_on_path
      The variable PATH should eq "$before"
    End

    It 'prepends the fixed Homebrew prefix bin dir when brew is missing from PATH but installed there (TASK-78)'
      fake_prefix="$(mktemp -d)"
      mkdir -p "$fake_prefix/bin"
      printf '#!/bin/sh\necho fake-brew\n' > "$fake_prefix/bin/brew"
      chmod +x "$fake_prefix/bin/brew"
      lt_homebrew_prefix() { echo "$fake_prefix"; }
      PATH="/usr/bin:/bin"
      When call ensure_brew_on_path
      The variable PATH should include "$fake_prefix/bin:"
      rm -rf "$fake_prefix"
    End

    It 'does not error when brew is not resolvable anywhere (fixed prefix included)'
      lt_homebrew_prefix() { echo "/nonexistent-homebrew-prefix-$$"; }
      PATH="/usr/bin:/bin"
      before="$PATH"
      When call ensure_brew_on_path
      The status should be success
      The variable PATH should eq "$before"
    End
  End

  Describe 'acquire_lock() / release_lock() (TASK-84)'
    setup() {
      scratch="$(mktemp -d)"
      LT_LOCK_DIR="$scratch/lt-test.lock"
    }
    cleanup() { rm -rf "$scratch"; }
    BeforeEach 'setup'
    AfterEach 'cleanup'

    It 'creates the lock dir and records this process pid'
      When call acquire_lock
      The status should be success
      The path "$LT_LOCK_DIR" should be exist
      The contents of file "$LT_LOCK_DIR/pid" should eq "$$"
    End

    It 'release_lock removes the lock dir'
      acquire_lock
      When call release_lock
      The path "$LT_LOCK_DIR" should not be exist
    End

    It 'release_lock is a no-op when no lock was ever acquired'
      When call release_lock
      The status should be success
    End

    It 'a second acquire while the first is still held by a live pid dies with a clear error'
      # acquire_lock's die() path calls a real `exit`, which would tear down
      # the shellspec runner itself under `When call` (same-process). Run it
      # as a real subprocess instead, so its exit only ends that subprocess.
      acquire_lock
      When run command env LT_LOCK_DIR="$LT_LOCK_DIR" sh -c '. ./scripts/lib.sh && acquire_lock'
      The status should be failure
      The error should include 'appears to be running'
      The path "$LT_LOCK_DIR" should be exist
    End

    It 'reclaims a stale lock left by a pid that no longer exists'
      mkdir "$LT_LOCK_DIR"
      printf '999999999\n' > "$LT_LOCK_DIR/pid"
      When call acquire_lock
      The status should be success
      The contents of file "$LT_LOCK_DIR/pid" should eq "$$"
    End
  End

  Describe 'run()'
    It 'executes the command for real when DRY_RUN is false'
      DRY_RUN=false
      When call run echo hello-from-run
      The output should eq 'hello-from-run'
    End

    It 'only prints what would run, prefixed with "+", under DRY_RUN=true'
      DRY_RUN=true
      When call run echo hello-from-run
      The output should eq '  + echo hello-from-run'
    End
  End
End
