# shellcheck shell=bash
# Regression tests for scripts/install/06_set_globals.sh's LOCAL-scope pin
# tracking (TASK-83): pinning locally must record the target directory in
# $ASDF_DATA_DIR/langtoolchain-local-pins so uninstall can find it later
# (see spec/uninstall_runtimes_spec.sh for the read side of this).
Describe 'scripts/install/06_set_globals.sh'
  SCRIPT='./scripts/install/06_set_globals.sh'

  setup() {
    data_dir="$(mktemp -d)/toolchain-data"
    mkdir -p "$data_dir/shims"
    target_dir="$(mktemp -d)"
    config_file="$(mktemp)"
    export ASDF_DATA_DIR="$data_dir"
    export TOOL_VERSIONS_FILE="$config_file"
    pins_file="$data_dir/langtoolchain-local-pins"
  }
  cleanup() { rm -rf "$(dirname "$data_dir")" "$target_dir" "$config_file"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  Describe 'local scope'
    It 'records the target directory in the local-pins file'
      printf '# scope: local %s\npython 3.12.13\n' "$target_dir" > "$config_file"
      export DRY_RUN=false
      Mock asdf
        case "$1" in
          set) exit 0 ;;
          reshim) exit 0 ;;
        esac
      End
      When run "$SCRIPT"
      The output should include 'Pinning versions locally'
      The contents of file "$pins_file" should eq "$target_dir"
    End

    It 'does not record anything under DRY_RUN (nothing was really pinned)'
      printf '# scope: local %s\npython 3.12.13\n' "$target_dir" > "$config_file"
      export DRY_RUN=true
      When run "$SCRIPT"
      The output should include '+ asdf set'
      The path "$pins_file" should not be exist
    End

    It 'does not duplicate the directory when pinned twice'
      printf '# scope: local %s\npython 3.12.13\n' "$target_dir" > "$config_file"
      export DRY_RUN=false
      Mock asdf
        case "$1" in
          set) exit 0 ;;
          reshim) exit 0 ;;
        esac
      End
      "$SCRIPT" >/dev/null
      When run "$SCRIPT"
      The output should include 'Pinning versions locally'
      lines="$(( $(wc -l < "$pins_file") ))"
      The variable lines should eq 1
    End
  End

  Describe 'global scope (default)'
    It 'does not touch the local-pins file at all'
      printf 'python 3.12.13\n' > "$config_file"
      export DRY_RUN=false
      Mock asdf
        case "$1" in
          set) exit 0 ;;
          reshim) exit 0 ;;
        esac
      End
      When run "$SCRIPT"
      The output should include 'Setting global'
      The path "$pins_file" should not be exist
    End
  End
End
