# shellcheck shell=bash
# Regression tests for scripts/install/07_validate.sh, covering the two
# logic bugs fixed this session (TASK-53, TASK-57). No command mocking:
# the script's own shim-path check inspects $ASDF_DATA_DIR directly, so a
# real fake executable placed at $ASDF_DATA_DIR/shims/<cmd> is simpler and
# more faithful than shellspec's Mock (which always lands in shellspec's
# own mock bin dir, not an arbitrary path).
Describe 'scripts/install/07_validate.sh'
  SCRIPT='./scripts/install/07_validate.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir/shims"
    tool_versions="$(mktemp)"
  }
  cleanup() {
    rm -rf "$(dirname "$data_dir")"
    rm -f "$tool_versions"
  }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  # fake_cmd <name> <version-output>: drops an executable stub at
  # $data_dir/shims/<name> that just echoes <version-output>, mimicking
  # e.g. `rustc --version`.
  fake_cmd() {
    cat > "$data_dir/shims/$1" <<EOF
#!/usr/bin/env bash
echo "$2"
EOF
    chmod +x "$data_dir/shims/$1"
  }

  Describe 'shim-path check (TASK-57 regression)'
    It 'reports OK when the binary resolves under a custom (non-".asdf") ASDF_DATA_DIR'
      fake_cmd rustc 'rustc 1.94.0 (abc 2026-01-01)'
      printf 'rust 1.94.0\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      When run "$SCRIPT"
      The status should be success
      The output should include 'OK:   rustc ->'
      The output should not include 'WARN: rustc resolves outside asdf shims'
    End

    It 'WARNs (but still exits success) when the binary resolves outside asdf shims'
      # A system-wide install shadowing the asdf shim - real regression this
      # check exists to catch (see the WARN branch in 07_validate.sh's own
      # case statement), never exercised by any existing test until now.
      outside_dir="$(mktemp -d)"
      printf '#!/usr/bin/env bash\necho "rustc 1.94.0 (abc 2026-01-01)"\n' > "$outside_dir/rustc"
      chmod +x "$outside_dir/rustc"
      printf 'rust 1.94.0\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      export PATH="$outside_dir:$PATH"
      When run "$SCRIPT"
      The status should be success
      The output should include 'WARN: rustc resolves outside asdf shims'
      rm -rf "$outside_dir"
    End
  End

  Describe 'version-mismatch check (TASK-53 regression)'
    It 'WARNs when the installed version differs from .tool-versions'
      fake_cmd go 'go version go1.20.0 darwin/arm64'
      printf 'golang 1.26.1\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      When run "$SCRIPT"
      The output should include "WARN: go reports 'go version go1.20.0 darwin/arm64', expected version matching '1.26.1'"
    End

    It 'stays quiet (no WARN) when the installed version matches'
      fake_cmd rustc 'rustc 1.94.0 (abc 2026-01-01)'
      printf 'rust 1.94.0\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      When run "$SCRIPT"
      The output should not include 'WARN: rustc reports'
      The output should include 'rustc 1.94.0 (abc 2026-01-01)'
    End

    It 'skips the version comparison for a non-numeric alias like "lts" (no false WARN)'
      fake_cmd node 'v24.14.0'
      printf 'nodejs lts\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      When run "$SCRIPT"
      The output should not include 'WARN: node reports'
      The output should include 'v24.14.0'
    End
  End

  Describe 'command not found'
    It 'reports FAIL instead of erroring out'
      printf 'rust 1.94.0\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=false
      # This dev machine has a real rustc on PATH via its own real asdf
      # install - strip PATH down to just enough to run the script itself
      # (bash builtins, awk, mktemp, head, grep) so "not found" is genuine.
      export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
      When run "$SCRIPT"
      The status should be failure
      The output should include "FAIL: 'rustc' not found in PATH."
    End
  End

  Describe 'DRY_RUN=true'
    It 'skips all validation instead of reporting false failures'
      printf 'rust 1.94.0\n' > "$tool_versions"
      export ASDF_DATA_DIR="$data_dir" TOOL_VERSIONS_FILE="$tool_versions" DRY_RUN=true
      When run "$SCRIPT"
      The output should include 'dry-run: no runtimes were actually installed, skipping validation'
      The output should not include 'FAIL'
      The status should be success
    End
  End
End
