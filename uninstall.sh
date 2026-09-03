#!/usr/bin/env sh
# langtoolchain — one-line uninstaller
#
#   curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/uninstall.sh | sh
#
# Thin entry point — real logic lives in scripts/uninstall/*.sh. See
# install.sh (its sibling) for a more detailed line-by-line explanation of
# this local-clone-vs-curl dispatch — the two are intentionally identical
# in structure.
set -eu

# NOTE: kept in sync by hand with install.sh's copy of these same two
# lines — see install.sh for why this can't source lib.sh instead. If you
# change the defaults here, change install.sh too.
#
# Pinned to a specific commit, not a floating branch name (TASK-117.1,
# decision-1) — see install.sh's copy of this comment for the full
# reasoning. Keep this in sync with install.sh's BRANCH default by hand.
#
# LANGTOOLCHAIN_REPO_URL / LANGTOOLCHAIN_BRANCH (TASK-117.6): same opt-in
# override as install.sh — see its copy of this comment for the reasoning.
readonly REPO_URL="${LANGTOOLCHAIN_REPO_URL:-https://github.com/amosQP/langtoolchain.git}"
readonly BRANCH="${LANGTOOLCHAIN_BRANCH:-896b4c5a7ecf82f43056d0cae7bb787f1ab3ee83}"

# $0, not ${BASH_SOURCE[0]:-} (POSIX sh has no BASH_SOURCE) — see
# install.sh for why the -f check below is what actually does the real/
# piped-stdin discrimination, verified empirically there.
readonly SELF_PATH="$0"
if [ -n "$SELF_PATH" ] && [ -f "$SELF_PATH" ]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
  readonly SELF_DIR
fi

if [ -n "${SELF_DIR:-}" ] && [ -d "$SELF_DIR/scripts/uninstall" ]; then
  # Local clone: run in place, no network needed.
  exec sh "$SELF_DIR/scripts/uninstall/main.sh" "$@"
fi

# `curl | sh`: no local checkout exists, so fetch a throwaway one.
command -v git >/dev/null 2>&1 || {
  printf '%s\n' "ERROR: git is required for the one-line uninstaller (macOS ships it with Xcode Command Line Tools)." >&2
  exit 1
}

# See install.sh's copy of this check for the reasoning — only fires once
# we're actually about to fetch over the network.
if [ -n "${LANGTOOLCHAIN_REPO_URL:-}" ] || [ -n "${LANGTOOLCHAIN_BRANCH:-}" ]; then
  printf '%s\n' "WARNING: LANGTOOLCHAIN_REPO_URL/LANGTOOLCHAIN_BRANCH override detected (REPO_URL=$REPO_URL, BRANCH=$BRANCH) — this source has not been reviewed or pinned by this tool. Only use this to test your own fork/branch." >&2
fi

# Deliberately NOT `exec`d below — see install.sh for why: exec replaces
# this process image outright, which skips the trap on the successful
# path entirely (only fires on an early failure before we get here).
WORKDIR="$(mktemp -d)"
readonly WORKDIR
trap 'rm -rf "$WORKDIR"' EXIT

# clone_pinned <ref>: see install.sh's copy of this function for the full
# reasoning (fetches exactly <ref> — SHA, tag, or branch name — instead of
# trusting whatever a branch currently points to; `git clone --branch`
# can't reliably target an arbitrary commit SHA the way `fetch <ref>` can).
#######################################
# Clone exactly <ref> (SHA/tag/branch) into $WORKDIR/langtoolchain.
# Globals:
#   WORKDIR
#   REPO_URL
# Arguments:
#   $1: ref — commit SHA, tag, or branch name to fetch and check out
# Outputs:
#   None of its own — git's own (-q-quieted) output passes through unless
#   the caller redirects it (the retry loop below sends it to /dev/null).
# Returns:
#   0 if every git step succeeds; non-zero (the subshell's status) if any
#   step in the init/remote/fetch/checkout chain fails.
#######################################
clone_pinned() {
  rm -rf "$WORKDIR/langtoolchain"
  mkdir -p "$WORKDIR/langtoolchain"
  (
    cd "$WORKDIR/langtoolchain" &&
    git init -q &&
    git remote add origin "$REPO_URL" &&
    git fetch -q --depth 1 origin "$1" &&
    git checkout -q FETCH_HEAD
  )
}

# Retries a transient clone failure a few times before giving up (TASK-88)
# — see install.sh for why this is an inline duplicate of lib.sh's retry()
# rather than a shared call.
CLONE_ATTEMPT=1
until clone_pinned "$BRANCH" >/dev/null 2>&1; do
  if [ "$CLONE_ATTEMPT" -ge 3 ]; then
    printf '%s\n' "ERROR: git clone failed after $CLONE_ATTEMPT attempts." >&2
    exit 1
  fi
  printf '%s\n' "git clone failed (attempt $CLONE_ATTEMPT/3) — retrying..." >&2
  # No explicit rm -rf here — clone_pinned() removes $WORKDIR/langtoolchain
  # itself at the start of every attempt, including the next one this loop
  # triggers.
  sleep $((CLONE_ATTEMPT * 5))
  CLONE_ATTEMPT=$((CLONE_ATTEMPT + 1))
done
sh "$WORKDIR/langtoolchain/scripts/uninstall/main.sh" "$@"
exit $?
