# shellcheck shell=bash
# Regression guard for TASK-105: install.sh and uninstall.sh are deliberately
# separate, independently curl-able entry points (see readme.md's "코드
# 구조" section) - never bundled into one script that dispatches on a mode
# flag. This locks that decision in so a future edit can't quietly merge
# them back together.
Describe 'install.sh / uninstall.sh entry points (TASK-105)'
  It 'both exist as separate executable files at the repo root'
    The path './install.sh' should be exist
    The path './uninstall.sh' should be exist
    The file './install.sh' should be executable
    The file './uninstall.sh' should be executable
  End

  It "install.sh has no code-level (non-comment) reference to uninstall.sh - not bundled"
    # Comments cross-referencing the sibling file for maintainers are fine
    # and expected (see both files' own header comments) - what this guards
    # against is an actual `sh uninstall.sh` / dispatch-on-mode-flag call.
    When run command sh -c "grep -v '^[[:space:]]*#' install.sh | grep -c uninstall.sh"
    The status should be failure
    The output should eq '0'
  End

  It "uninstall.sh has no code-level (non-comment) reference to install.sh - not bundled"
    When run command sh -c "grep -v '^[[:space:]]*#' uninstall.sh | grep -c install.sh"
    The status should be failure
    The output should eq '0'
  End

  It 'each has its own independent curl-fetchable REPO_URL/BRANCH bootstrap'
    The contents of file './install.sh' should include 'REPO_URL='
    The contents of file './uninstall.sh' should include 'REPO_URL='
  End
End
