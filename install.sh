#!/usr/bin/env bash
# langtoolchain — one-line installer
#
#   curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | bash
#
# This file only gets the real installer onto disk and runs it. The actual
# logic lives in scripts/install/*.sh (one file per responsibility) so it's
# easy to read, test, and modify one phase at a time — see readme.md.
#
# Any flags you pass are forwarded, e.g.:
#   curl -fsSL .../install.sh | bash -s -- --all --yes
set -euo pipefail

# Where to fetch a fresh checkout from, when there isn't one on disk already.
REPO_URL="https://github.com/amosQP/langtoolchain.git"
BRANCH="main"

# ${BASH_SOURCE[0]:-} is this file's own path *if* bash knows it (i.e. it
# was executed/sourced from an actual file on disk) — it's empty when the
# script's content was streamed straight into bash's stdin, which is
# exactly what `curl | bash` does.
SELF_PATH="${BASH_SOURCE[0]:-}"
if [[ -n "$SELF_PATH" && -f "$SELF_PATH" ]]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
fi

if [[ -n "${SELF_DIR:-}" && -d "$SELF_DIR/scripts/install" ]]; then
  # Running from an existing local clone — use it as-is, no network needed.
  # `exec` replaces this process instead of spawning a child, so there's no
  # extra shell left dangling once the real installer takes over.
  exec bash "$SELF_DIR/scripts/install/main.sh" "$@"
fi

# Running via `curl | bash` — there is no local checkout, so fetch one.
command -v git >/dev/null 2>&1 || {
  echo "ERROR: git is required for the one-line installer (macOS ships it with Xcode Command Line Tools)." >&2
  exit 1
}

# A scratch directory for the throwaway clone.
WORKDIR="$(mktemp -d)"
# Clean it up no matter how this script exits (success, error, Ctrl-C).
trap 'rm -rf "$WORKDIR"' EXIT

# --depth 1: only the latest commit, not the full history — this clone is
# thrown away right after, so there's no reason to download more than
# necessary.
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/langtoolchain" >/dev/null
exec bash "$WORKDIR/langtoolchain/scripts/install/main.sh" "$@"
