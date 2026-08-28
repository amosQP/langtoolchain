#!/usr/bin/env sh
# langtoolchain — one-line installer
#
#   curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | sh
#
# This file only gets the real installer onto disk and runs it. The actual
# logic lives in scripts/install/*.sh (one file per responsibility) so it's
# easy to read, test, and modify one phase at a time — see readme.md.
#
# Any flags you pass are forwarded, e.g.:
#   curl -fsSL .../install.sh | sh -s -- --all --yes
set -eu

# Where to fetch a fresh checkout from, when there isn't one on disk already.
# NOTE: kept in sync by hand with uninstall.sh's copy of these same two
# lines. This file runs via `curl | bash` before any repo is on disk, so it
# can't `source` lib.sh for a shared constant (chicken-and-egg: lib.sh lives
# inside the very repo this script's job is to fetch). If you change
# REPO_URL/BRANCH here, change uninstall.sh too.
REPO_URL="https://github.com/amosQP/langtoolchain.git"
BRANCH="main"

# $0 is this file's own path when it was executed from an actual file on
# disk — but POSIX sh has no BASH_SOURCE, and unlike bash, $0 is USUALLY
# non-empty even when the script's content was streamed straight into sh's
# stdin (curl | sh sets it to something like "sh", not empty). The `-f`
# check below is what actually does the discrimination: a real on-disk
# invocation gives a $0 that resolves to an existing file, while the
# piped-stdin case gives a bare interpreter name with no such file in the
# current directory. Verified empirically for both cases.
SELF_PATH="$0"
if [ -n "$SELF_PATH" ] && [ -f "$SELF_PATH" ]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
fi

if [ -n "${SELF_DIR:-}" ] && [ -d "$SELF_DIR/scripts/install" ]; then
  # Running from an existing local clone — use it as-is, no network needed.
  # `exec` replaces this process instead of spawning a child, so there's no
  # extra shell left dangling once the real installer takes over.
  exec sh "$SELF_DIR/scripts/install/main.sh" "$@"
fi

# Running via `curl | bash` — there is no local checkout, so fetch one.
command -v git >/dev/null 2>&1 || {
  echo "ERROR: git is required for the one-line installer (macOS ships it with Xcode Command Line Tools)." >&2
  exit 1
}

# A scratch directory for the throwaway clone.
WORKDIR="$(mktemp -d)"
# Clean it up no matter how this script exits (success, error, Ctrl-C).
#
# Deliberately NOT `exec`d below: exec replaces this process image outright
# (execve), which skips the shell's own exit sequence entirely — so a trap
# registered here would never fire on the common (successful) path, only
# on an early failure before we ever get there. Confirmed empirically.
# Plain invocation + explicit exit lets this trap actually run every time.
trap 'rm -rf "$WORKDIR"' EXIT

# --depth 1: only the latest commit, not the full history — this clone is
# thrown away right after, so there's no reason to download more than
# necessary.
#
# Retries a transient clone failure (network blip) a few times before
# giving up entirely (TASK-88). lib.sh's retry() isn't available here — see
# the note above on why this file can't source it — so this is a small
# inline equivalent, same idea as REPO_URL/BRANCH already being duplicated
# rather than shared.
CLONE_ATTEMPT=1
until git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/langtoolchain" >/dev/null 2>&1; do
  if [ "$CLONE_ATTEMPT" -ge 3 ]; then
    echo "ERROR: git clone failed after $CLONE_ATTEMPT attempts." >&2
    exit 1
  fi
  echo "git clone failed (attempt $CLONE_ATTEMPT/3) — retrying..." >&2
  rm -rf "$WORKDIR/langtoolchain"
  sleep $((CLONE_ATTEMPT * 5))
  CLONE_ATTEMPT=$((CLONE_ATTEMPT + 1))
done
sh "$WORKDIR/langtoolchain/scripts/install/main.sh" "$@"
exit $?
