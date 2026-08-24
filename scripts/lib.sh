#!/usr/bin/env bash
# Shared utilities sourced by the phase scripts under scripts/install/ and
# scripts/uninstall/. Pure functions only — sourcing this file has no side
# effects, so any phase script can source it standalone, in any order,
# without depending on another phase script having run first.
#
# Written for bash 3.2 (macOS's stock /bin/bash) — no associative arrays,
# no bash-4-only syntax.

DRY_RUN="${DRY_RUN:-false}"

log()  { printf '%s\n' "$*"; }
step() { printf '\n== %s ==\n' "$*"; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# run <cmd...>: executes, or just prints under DRY_RUN=true
run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '  + %s\n' "$*"
  else
    "$@"
  fi
}

# Each phase script locates the repo root itself from its own path, instead
# of trusting a caller's cwd or an inherited variable.
repo_root_from() {
  ( cd "$(dirname "$1")/../.." && pwd )
}

# Reads a .tool-versions-style file, printing "plugin version" pairs,
# skipping comments and blank lines.
each_tool() {
  awk '/^[^# \t]/ {print $1, $2}' "$1"
}

detect_rc_file() {
  case "$(basename "${SHELL:-}")" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bash_profile" ;;  # macOS Terminal runs login shells
    *)    echo "$HOME/.zshrc" ;;
  esac
}

# Idempotently appends a line to an rc file, keyed off a grep search string.
append_env_var() {
  local rc_file="$1" search="$2" line="$3"
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '  + append to %s if missing: %s\n' "$rc_file" "$line"
    return
  fi
  grep -q "$search" "$rc_file" 2>/dev/null || printf '%s\n' "$line" >> "$rc_file"
}

# Modern Homebrew asdf (v0.16+, the Go rewrite) is a single binary with no
# libexec/asdf.sh to source — shell integration is just putting
# $ASDF_DATA_DIR/shims on PATH. Every phase that shells out to `asdf` or an
# asdf shim calls this first, so no phase depends on another phase having
# exported anything into this process already.
ensure_asdf_on_path() {
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  case ":$PATH:" in
    *":$ASDF_DATA_DIR/shims:"*) ;;
    *) export PATH="$ASDF_DATA_DIR/shims:$PATH" ;;
  esac
}

# Re-exports the Homebrew build flags Python (and friends) need to compile
# against keg-only openssl/readline/sqlite3/zlib. Any phase that runs
# `asdf install` calls this itself rather than trusting an earlier phase's
# export to still be in scope.
ensure_build_flags() {
  export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
  export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix sqlite3)/lib -L$(brew --prefix zlib)/lib"
  export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix readline)/include -I$(brew --prefix sqlite3)/include -I$(brew --prefix zlib)/include"
  export PKG_CONFIG_PATH="$(brew --prefix openssl)/lib/pkgconfig:$(brew --prefix readline)/lib/pkgconfig:$(brew --prefix sqlite3)/lib/pkgconfig"
}

# plugin name -> primary CLI binary (case instead of an associative array,
# since bash 3.2 — macOS's stock /bin/bash — has none)
binary_for_plugin() {
  case "$1" in
    nodejs) echo node ;;
    java)   echo java ;;
    python) echo python ;;
    rust)   echo rustc ;;
    golang) echo go ;;
    *)      echo "$1" ;;
  esac
}

# binary -> its version flag
flag_for_binary() {
  case "$1" in
    node)   echo -v ;;
    java)   echo -version ;;
    python) echo --version ;;
    rustc)  echo --version ;;
    go)     echo version ;;
    *)      echo --version ;;
  esac
}
