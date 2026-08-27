# shellcheck shell=bash
# Tests for scripts/install/00_select.sh's non-interactive paths (--all,
# --local[=DIR]). The interactive /dev/tty prompt path isn't covered here -
# it genuinely needs a real terminal (see backlog TASK-27/39/47) - but
# every non-interactive branch (the one `curl | bash` actually takes in a
# script/CI context, since there's no controlling tty) is deterministic and
# exercised here.
Describe 'scripts/install/00_select.sh'
  SCRIPT='./scripts/install/00_select.sh'

  It 'writes the default .tool-versions languages with a global scope line under --all'
    When run "$SCRIPT" --all
    out_file="$(tail -n1 "$SHELLSPEC_STDOUT_FILE")"
    The status should be success
    The output should include "$out_file"
    The contents of file "$out_file" should include '# scope: global'
    The contents of file "$out_file" should include 'nodejs lts'
    The contents of file "$out_file" should include 'golang 1.26.1'
    rm -f "$out_file"
  End

  It 'writes a local scope line pointing at the given directory under --local=DIR'
    target_dir="$(mktemp -d)"
    When run "$SCRIPT" --all --local="$target_dir"
    out_file="$(tail -n1 "$SHELLSPEC_STDOUT_FILE")"
    The status should be success
    The output should include "$out_file"
    The contents of file "$out_file" should include "# scope: local $target_dir"
    rm -f "$out_file"
    rmdir "$target_dir"
  End

  It 'fails with a clear error when --local points at a directory that does not exist'
    When run "$SCRIPT" --all --local=/no/such/directory/anywhere
    The status should be failure
    The error should include 'Directory not found'
  End

  It 'has no controlling tty in this test process, so a bare run also takes the non-interactive path'
    When run "$SCRIPT"
    out_file="$(tail -n1 "$SHELLSPEC_STDOUT_FILE")"
    The status should be success
    The output should include "$out_file"
    The contents of file "$out_file" should include '# scope: global'
    rm -f "$out_file"
  End
End
