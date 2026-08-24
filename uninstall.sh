#!/usr/bin/env bash
# langtoolchain — one-line uninstaller
#
#   curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/uninstall.sh | bash
#
# Thin entry point — real logic lives in scripts/uninstall/*.sh. See
# install.sh (its sibling) for a more detailed line-by-line explanation of
# this local-clone-vs-curl dispatch — the two are intentionally identical
# in structure.
set -euo pipefail

REPO_URL="https://github.com/amosQP/langtoolchain.git"
BRANCH="main"

SELF_PATH="${BASH_SOURCE[0]:-}"
if [[ -n "$SELF_PATH" && -f "$SELF_PATH" ]]; then
  SELF_DIR="$(cd "$(dirname "$SELF_PATH")" && pwd)"
fi

if [[ -n "${SELF_DIR:-}" && -d "$SELF_DIR/scripts/uninstall" ]]; then
  # Local clone: run in place, no network needed.
  exec bash "$SELF_DIR/scripts/uninstall/main.sh" "$@"
fi

# `curl | bash`: no local checkout exists, so fetch a throwaway one.
command -v git >/dev/null 2>&1 || {
  echo "ERROR: git is required for the one-line uninstaller (macOS ships it with Xcode Command Line Tools)." >&2
  exit 1
}

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/langtoolchain" >/dev/null
exec bash "$WORKDIR/langtoolchain/scripts/uninstall/main.sh" "$@"
