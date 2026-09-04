# shellcheck shell=bash
# Regression tests for LANGTOOLCHAIN_REPO_URL/LANGTOOLCHAIN_BRANCH
# (TASK-117.6) and, by extension, the pinned-fetch mechanism itself
# (clone_pinned(), TASK-117.1) that install.sh/uninstall.sh use to reach
# the network-clone branch.
#
# Before TASK-117.6, REPO_URL/BRANCH were hardcoded with no way to point
# them anywhere but the real amosQP/langtoolchain repo on GitHub - README's
# own "Known limitations" section documented this as untestable locally.
# The override support this task adds is what makes it possible to finally
# exercise the network-clone path in a local spec, entirely against a
# throwaway local bare repo (file:// URL) - no real network access, no
# GitHub dependency, consistent with this project's rule against touching
# real external systems from local specs.
#
# `sh -s -- <args> < install.sh` is the mechanism that simulates
# `curl | sh`: piping the script body into stdin gives $0 a bare
# interpreter name ("sh"), not a resolvable file path, so install.sh's own
# on-disk-vs-piped-stdin discrimination (see its SELF_PATH/-f check) takes
# the same branch a real curl|sh invocation would - the local-clone
# shortcut is skipped and the fixture repo actually gets fetched over
# clone_pinned().
Describe 'LANGTOOLCHAIN_REPO_URL / LANGTOOLCHAIN_BRANCH override (TASK-117.6)'
  # build_fixture_repo: a throwaway git repo with two commits - an "old"
  # one with no scripts/*/main.sh (so execing into it fails loudly and
  # distinctly), and a "new" one whose stub main.sh just echoes a marker
  # and its own args. Pinning BRANCH to one SHA vs the other is what
  # proves clone_pinned() fetched the *exact* commit asked for, not just
  # "a" commit or the branch tip.
  build_fixture_repo() {
    src="$(mktemp -d)/src"
    mkdir -p "$src"
    ( cd "$src" &&
      git init -q &&
      git config user.email test@example.com &&
      git config user.name test &&
      printf 'old, no main.sh\n' > README.txt &&
      git add README.txt &&
      git commit -qm "old: no main.sh" )
    old_sha="$(cd "$src" && git rev-parse HEAD)"

    mkdir -p "$src/scripts/install" "$src/scripts/uninstall"
    printf '#!/bin/sh\necho "MARKER: install-pinned-ok $*"\n' \
      > "$src/scripts/install/main.sh"
    printf '#!/bin/sh\necho "MARKER: uninstall-pinned-ok $*"\n' \
      > "$src/scripts/uninstall/main.sh"
    chmod +x "$src/scripts/install/main.sh" "$src/scripts/uninstall/main.sh"
    ( cd "$src" &&
      git add scripts &&
      git commit -qm "new: has main.sh" )
    new_sha="$(cd "$src" && git rev-parse HEAD)"

    bare="$(mktemp -d)/bare.git"
    git clone -q --bare "$src" "$bare" >/dev/null
    rm -rf "$src"
  }

  setup() { build_fixture_repo; }
  cleanup() { rm -rf "$(dirname "$bare")"; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  Describe 'install.sh'
    It 'fetches the exact pinned commit and warns that the source is unreviewed'
      When run command sh -c 'LANGTOOLCHAIN_REPO_URL="file://$1" LANGTOOLCHAIN_BRANCH="$2" sh -s -- --dry-run < ./install.sh' -- "$bare" "$new_sha"
      The status should be success
      The output should include 'MARKER: install-pinned-ok --dry-run'
      The error should include 'WARNING: LANGTOOLCHAIN_REPO_URL/'\
'LANGTOOLCHAIN_BRANCH override detected'
    End

    It 'checks out the OLD commit, not the branch tip, when pinned to'\
' it (proves exact-ref fetch, not "latest")'
      When run command sh -c 'LANGTOOLCHAIN_REPO_URL="file://$1" LANGTOOLCHAIN_BRANCH="$2" sh -s -- --dry-run < ./install.sh' -- "$bare" "$old_sha"
      The status should be failure
      The error should include 'main.sh: No such file or directory'
    End
  End

  Describe 'uninstall.sh'
    It 'fetches the exact pinned commit and warns that the source is unreviewed'
      When run command sh -c 'LANGTOOLCHAIN_REPO_URL="file://$1" LANGTOOLCHAIN_BRANCH="$2" sh -s -- --dry-run < ./uninstall.sh' -- "$bare" "$new_sha"
      The status should be success
      The output should include 'MARKER: uninstall-pinned-ok --dry-run'
      The error should include 'WARNING: LANGTOOLCHAIN_REPO_URL/'\
'LANGTOOLCHAIN_BRANCH override detected'
    End
  End
End
