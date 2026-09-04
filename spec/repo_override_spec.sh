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

# clone_pinned()'s `git fetch` used to have no wall-clock timeout at all
# (TASK-145.3) - install.sh/uninstall.sh each now carry their own inline
# clone_fetch_with_timeout(), a small duplicate of lt_run_with_timeout()'s
# (scripts/lib.sh, TASK-138.1) watchdog idea, since neither file can
# source lib.sh (no repo on disk yet) or rely on timeout(1)/gtimeout(1)
# (pre-Homebrew, decision-10). This proves the watchdog actually fires: a
# fake `git` on PATH that always hangs on `fetch` (simulating decision-10's
# DNS/TCP/TLS handshake blackhole - no real network used) still makes the
# whole `curl | sh` path fail well inside the 3-attempt retry loop's total
# budget, instead of hanging for real.
Describe 'clone_pinned() fetch timeout (TASK-145.3, decision-10)'
  # A blackholed `git fetch` that's never killed would hang the full 30s
  # LANGTOOLCHAIN_CLONE_TIMEOUT default on every one of the retry loop's 3
  # attempts (90s+, plus its 5s/10s backoff sleeps) before ever failing.
  # LANGTOOLCHAIN_CLONE_TIMEOUT=1 below shrinks that per-attempt budget so
  # a fixed clone_fetch_with_timeout() kills the hang almost immediately
  # each time - all 3 attempts plus both backoff sleeps still finish in
  # well under this test's 25s bound, while the pre-fix behavior (no kill
  # at all) would still be sleeping through attempt 1 alone at 25s.
  make_fake_git_that_hangs_on_fetch() {
    fake_bin="$(mktemp -d)"
    cat > "$fake_bin/git" <<'FAKE_GIT'
#!/bin/sh
case "$1" in
  fetch) sleep 30 ;;
  *) exit 0 ;;
esac
FAKE_GIT
    chmod +x "$fake_bin/git"
  }

  cleanup() { rm -rf "$fake_bin"; }
  AfterEach 'cleanup'

  It 'install.sh: fails well inside the retry budget instead of hanging'
    make_fake_git_that_hangs_on_fetch
    start_ts=$(date +%s)
    status=0
    PATH="$fake_bin:$PATH" LANGTOOLCHAIN_REPO_URL="file:///nonexistent" \
      LANGTOOLCHAIN_BRANCH="deadbeef" LANGTOOLCHAIN_CLONE_TIMEOUT=1 \
      sh -s -- --dry-run < ./install.sh >/dev/null 2>&1 || status=$?
    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))
    failed_fast=false
    [ "$status" -ne 0 ] && [ "$elapsed" -lt 25 ] && failed_fast=true
    When call true
    The variable failed_fast should eq 'true'
  End

  It 'uninstall.sh: fails well inside the retry budget instead of hanging'
    make_fake_git_that_hangs_on_fetch
    start_ts=$(date +%s)
    status=0
    PATH="$fake_bin:$PATH" LANGTOOLCHAIN_REPO_URL="file:///nonexistent" \
      LANGTOOLCHAIN_BRANCH="deadbeef" LANGTOOLCHAIN_CLONE_TIMEOUT=1 \
      sh -s -- --dry-run < ./uninstall.sh >/dev/null 2>&1 || status=$?
    end_ts=$(date +%s)
    elapsed=$((end_ts - start_ts))
    failed_fast=false
    [ "$status" -ne 0 ] && [ "$elapsed" -lt 25 ] && failed_fast=true
    When call true
    The variable failed_fast should eq 'true'
  End
End
