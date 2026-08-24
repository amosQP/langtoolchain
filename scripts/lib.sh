#!/usr/bin/env bash
# Shared utilities sourced by the phase scripts under scripts/install/ and
# scripts/uninstall/. Pure functions only — sourcing this file has no side
# effects, so any phase script can source it standalone, in any order,
# without depending on another phase script having run first.
#
# Written for bash 3.2 (macOS's stock /bin/bash) — no associative arrays,
# no bash-4-only syntax.

# DRY_RUN is exported by main.sh before it launches each phase script as a
# child process. `:-false` makes this file safe to source on its own too
# (e.g. while testing a single phase by hand) — it just defaults to "do it
# for real".
DRY_RUN="${DRY_RUN:-false}"

# log <msg>: plain status line to stdout.
log()  { printf '%s\n' "$*"; }
# step <msg>: a section header, e.g. "== Phase 3: ... ==", to visually
# separate phases in the console output.
step() { printf '\n== %s ==\n' "$*"; }
# die <msg>: print to stderr and exit the whole script immediately.
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# run <cmd...>: the dry-run gate. Every command that actually mutates the
# system (brew install, asdf install, rm -rf, ...) goes through this
# instead of being called directly.
run() {
  # Under --dry-run, print what *would* run (prefixed with "+", like `set -x`)
  # instead of running it.
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '  + %s\n' "$*"
  else
    # "$@" preserves each argument's word boundaries/quoting exactly as the
    # caller passed them — unlike "$*", this is safe for arguments with
    # spaces.
    "$@"
  fi
}

# repo_root_from <path-to-a-file-inside-scripts/install-or-uninstall>:
# prints the repository root (two directories up from scripts/install/ or
# scripts/uninstall/). Each phase script calls this with its own
# ${BASH_SOURCE[0]} so it can find .tool-versions regardless of the
# caller's current working directory.
repo_root_from() {
  # Run in a subshell so the `cd` here doesn't change the calling script's
  # own working directory; `pwd` then prints the absolute, resolved path.
  ( cd "$(dirname "$1")/../.." && pwd )
}

# each_tool <config-file>: reads a .tool-versions-style file and prints
# "plugin version" pairs, one per line — skipping comment lines (starting
# with #) and blank/whitespace-only lines.
each_tool() {
  # /^[^# \t]/ matches lines whose first character is neither '#' nor a
  # space/tab, i.e. real plugin lines; $1/$2 are the plugin name and version
  # columns.
  awk '/^[^# \t]/ {print $1, $2}' "$1"
}

# detect_rc_file: prints the shell rc file the installer should edit,
# based on the user's login shell ($SHELL), not the shell currently running
# this script (curl | bash always runs under bash regardless of what the
# user actually uses day to day).
detect_rc_file() {
  case "$(basename "${SHELL:-}")" in
    zsh)  echo "$HOME/.zshrc" ;;
    bash) echo "$HOME/.bash_profile" ;;  # macOS Terminal runs login shells
    *)    echo "$HOME/.zshrc" ;;         # unknown shell: default to zsh (macOS's own default since Catalina)
  esac
}

# append_env_var <rc_file> <search> <line>: appends <line> to <rc_file>,
# unless <rc_file> already contains something matching the grep pattern
# <search> — so re-running the installer never duplicates a line.
append_env_var() {
  local rc_file="$1" search="$2" line="$3"
  if [[ "$DRY_RUN" == "true" ]]; then
    # Dry-run: describe the write instead of performing it.
    printf '  + append to %s if missing: %s\n' "$rc_file" "$line"
    return
  fi
  # grep -q: no output, just an exit code. 2>/dev/null swallows the "no
  # such file" error the very first time this runs against a fresh rc file
  # (grep failing is also what makes `||` fall through to appending).
  grep -q "$search" "$rc_file" 2>/dev/null || printf '%s\n' "$line" >> "$rc_file"
}

# prepend_env_var <rc_file> <search> <line>: like append_env_var, but
# inserts <line> at the very TOP of the file instead of the bottom.
#
# Order matters for PATH: whichever export runs LAST at shell startup wins
# (each `export PATH="X:$PATH"` prepends X ahead of everything already
# there). `brew shellenv` needs to run before asdf's shim PATH line — not
# after — or a Homebrew formula that happens to share a name with
# something asdf manages (e.g. a `node` formula installed some other way)
# would silently shadow the asdf shim. append_env_var can't guarantee this
# on a machine with a pre-existing rc file, since it only ever adds to the
# bottom; this guarantees first-in-file, and therefore correct priority,
# regardless of what else already lives in the rc file.
prepend_env_var() {
  local rc_file="$1" search="$2" line="$3"
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '  + prepend to %s if missing: %s\n' "$rc_file" "$line"
    return
  fi
  grep -q "$search" "$rc_file" 2>/dev/null && return
  local tmp
  tmp="$(mktemp)"
  # New line first, then the file's existing content, all written to a
  # temp file, then swapped into place — `cat` never edits a file in place
  # while also reading from it.
  { printf '%s\n' "$line"; cat "$rc_file"; } > "$tmp"
  mv "$tmp" "$rc_file"
}

# read_scope <config_file>: reads the optional "# scope: ..." first line a
# selection file from 00_select.sh may carry, and prints either "global" or
# "local:<dir>". A config file with no such line (including this repo's own
# .tool-versions, which nothing ever adds this line to) defaults to
# "global" — keeps every phase working unmodified when TOOL_VERSIONS_FILE
# isn't set.
read_scope() {
  local config_file="$1" first_line
  first_line="$(head -n 1 "$config_file" 2>/dev/null)"
  case "$first_line" in
    "# scope: local "*) echo "local:${first_line#"# scope: local "}" ;;
    *)                  echo "global" ;;
  esac
}

# Modern Homebrew asdf (v0.16+, the Go rewrite) is a single binary with no
# libexec/asdf.sh to source — shell integration is just putting
# $ASDF_DATA_DIR/shims on PATH. Every phase that shells out to `asdf` or an
# asdf shim calls this first, so no phase depends on another phase having
# exported anything into this process already (main.sh runs each phase as
# its own separate `bash` child process, so nothing carries over
# automatically).
ensure_asdf_on_path() {
  # Default to asdf's own default data directory if the caller's
  # environment hasn't already set ASDF_DATA_DIR.
  export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  # Only prepend the shims directory if it isn't already on PATH — colons
  # bracket the check so a partial/substring match (e.g. a differently
  # named sibling directory) can't produce a false positive.
  case ":$PATH:" in
    *":$ASDF_DATA_DIR/shims:"*) ;;                      # already present: no-op
    *) export PATH="$ASDF_DATA_DIR/shims:$PATH" ;;      # not present: prepend it
  esac
}

# ensure_brew_on_path: makes `brew` callable from *this* process, even if
# Homebrew was only just installed moments ago by a DIFFERENT phase's
# process (main.sh runs every phase as its own `bash` child, so nothing
# exported by phase 01's Homebrew install carries over automatically).
#
# Homebrew's own installer never edits PATH itself — it prints an
# `eval "$(brew shellenv)"` line for the user to add to their rc file by
# hand, which only takes effect in brand-new shells. Since our own rc-file
# write for that line (see 04_configure_shell_env.sh) doesn't help THIS
# still-running install either, this falls back to Homebrew's two
# fixed, architecture-specific install locations directly.
ensure_brew_on_path() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi
  local brew_bin
  case "$(uname -m)" in
    arm64) brew_bin="/opt/homebrew/bin" ;;   # Apple Silicon
    *)     brew_bin="/usr/local/bin" ;;      # Intel
  esac
  if [[ -x "$brew_bin/brew" ]]; then
    export PATH="$brew_bin:$PATH"
  fi
}

# ensure_build_flags: re-exports the Homebrew build flags Python (and
# friends) need to compile against keg-only openssl/readline/sqlite3/zlib.
# Homebrew deliberately doesn't put keg-only formulas on PATH/in the
# compiler's default search path, so without these exports `asdf install
# python ...` fails to find OpenSSL/SQLite headers. Any phase that runs
# `asdf install` calls this itself rather than trusting an earlier phase's
# export to still be in scope (again: separate child processes).
ensure_build_flags() {
  # `brew --prefix` below needs `brew` itself resolvable first.
  ensure_brew_on_path
  export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
  export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(brew --prefix sqlite3)/lib -L$(brew --prefix zlib)/lib"
  export CPPFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix readline)/include -I$(brew --prefix sqlite3)/include -I$(brew --prefix zlib)/include"
  export PKG_CONFIG_PATH="$(brew --prefix openssl)/lib/pkgconfig:$(brew --prefix readline)/lib/pkgconfig:$(brew --prefix sqlite3)/lib/pkgconfig"
}

# binary_for_plugin <asdf-plugin-name>: prints the primary CLI command that
# plugin installs (e.g. "nodejs" -> "node"). Implemented as a `case`
# instead of an associative array (`declare -A`) because bash 3.2 — the
# actual /bin/bash macOS ships — predates associative arrays entirely, and
# `curl | bash` may run under whatever `bash` is first on the user's PATH.
binary_for_plugin() {
  case "$1" in
    nodejs) echo node ;;
    java)   echo java ;;
    python) echo python ;;
    rust)   echo rustc ;;
    golang) echo go ;;
    *)      echo "$1" ;;   # unknown plugin: assume the plugin name IS the binary name
  esac
}

# flag_for_binary <binary-name>: prints the flag that binary uses to print
# its own version (they're not all the same — `go version` has no dashes,
# `node -v` is a short flag, `java -version` is a single dash, etc).
flag_for_binary() {
  case "$1" in
    node)   echo -v ;;
    java)   echo -version ;;
    python) echo --version ;;
    rustc)  echo --version ;;
    go)     echo version ;;
    *)      echo --version ;;   # unknown binary: guess the common long flag
  esac
}
