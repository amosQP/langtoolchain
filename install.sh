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

REPO_URL="https://github.com/amosQP/langtoolchain.git"
BRANCH="main"

SELF_PATH="${BASH_SOURCE[0]:-}"
if [[ -n "$SELF_PATH" && -f "$SELF_PATH" ]]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
fi

if [[ -n "${SELF_DIR:-}" && -d "$SELF_DIR/scripts/install" ]]; then
  # Running from an existing local clone — use it as-is, no network needed.
  exec bash "$SELF_DIR/scripts/install/main.sh" "$@"
fi

# Running via `curl | bash` — there is no local checkout, so fetch one.
command -v git >/dev/null 2>&1 || {
  echo "ERROR: git is required for the one-line installer (macOS ships it with Xcode Command Line Tools)." >&2
  exit 1
}

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/langtoolchain" >/dev/null
exec bash "$WORKDIR/langtoolchain/scripts/install/main.sh" "$@"
