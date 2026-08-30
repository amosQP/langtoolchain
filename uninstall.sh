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
# change REPO_URL/BRANCH here, change install.sh too.
REPO_URL="https://github.com/amosQP/langtoolchain.git"
BRANCH="main"

# $0, not ${BASH_SOURCE[0]:-} (POSIX sh has no BASH_SOURCE) — see
# install.sh for why the -f check below is what actually does the real/
# piped-stdin discrimination, verified empirically there.
SELF_PATH="$0"
if [ -n "$SELF_PATH" ] && [ -f "$SELF_PATH" ]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
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

# Deliberately NOT `exec`d below — see install.sh for why: exec replaces
# this process image outright, which skips the trap on the successful
# path entirely (only fires on an early failure before we get here).
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

# Retries a transient clone failure a few times before giving up (TASK-88)
# — see install.sh for why this is an inline duplicate of lib.sh's retry()
# rather than a shared call.
CLONE_ATTEMPT=1
until git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/langtoolchain" >/dev/null 2>&1; do
  if [ "$CLONE_ATTEMPT" -ge 3 ]; then
    printf '%s\n' "ERROR: git clone failed after $CLONE_ATTEMPT attempts." >&2
    exit 1
  fi
  printf '%s\n' "git clone failed (attempt $CLONE_ATTEMPT/3) — retrying..." >&2
  rm -rf "$WORKDIR/langtoolchain"
  sleep $((CLONE_ATTEMPT * 5))
  CLONE_ATTEMPT=$((CLONE_ATTEMPT + 1))
done
sh "$WORKDIR/langtoolchain/scripts/uninstall/main.sh" "$@"
exit $?
