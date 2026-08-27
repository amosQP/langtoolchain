#!/usr/bin/env bash
# Writes asdf + build-flag shell config into the user's rc file.
#
# Modern Homebrew asdf (v0.16+, the Go rewrite — what `brew install asdf`
# gives you today) is a single binary with no libexec/asdf.sh to source.
# Shell integration is just: put $ASDF_DATA_DIR/shims on PATH. The previous
# version of this tool tried to source that nonexistent file and silently
# did nothing — this replaces that with the two exports asdf actually needs.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../lib.sh"

step "Phase 4: Configuring shell environment"

# Which rc file to edit depends on the user's actual login shell ($SHELL),
# not whatever shell happens to be running this installer.
RC_FILE="$(detect_rc_file)"
# Make sure the file exists before grep/sed touch it (e.g. a brand new
# machine with no .bash_profile yet).
run touch "$RC_FILE"
log "Using rc file: $RC_FILE"

# Homebrew's own installer never edits shell config itself — it just prints
# this line as a suggested next step. Write it in for the user — at the
# TOP of the file (prepend, not append): this needs to run before asdf's
# shim PATH line so asdf can correctly win over any same-named Homebrew
# formula (e.g. a separately brew-installed `node`) rather than being
# silently shadowed by it.
BREW_BIN="$(lt_homebrew_prefix)/bin/brew"
prepend_env_var "$RC_FILE" "brew shellenv" "eval \"\$($BREW_BIN shellenv)\""

# The two lines modern asdf actually needs: where its data lives, and
# putting its shim directory ahead of everything else on PATH so `node`,
# `python`, etc. resolve to the asdf-managed versions.
append_env_var "$RC_FILE" "ASDF_DATA_DIR" 'export ASDF_DATA_DIR="$HOME/.asdf"'
append_env_var "$RC_FILE" "ASDF_DATA_DIR/shims" 'export PATH="$ASDF_DATA_DIR/shims:$PATH"'

# Java home hook — pick the variant matching the detected shell (the
# asdf-java plugin ships both; sourcing the wrong one would just silently
# do nothing in that shell).
case "$RC_FILE" in
  *.zshrc) JAVA_HOOK="set-java-home.zsh" ;;
  *)       JAVA_HOOK="set-java-home.bash" ;;
esac
# This makes $JAVA_HOME track whatever Java version asdf currently has set
# globally, every time a new shell starts.
append_env_var "$RC_FILE" "$JAVA_HOOK" ". \$HOME/.asdf/plugins/java/$JAVA_HOOK"

# Python build flags (openssl/readline/sqlite3/zlib are keg-only, so the
# compiler can't find them unless we point at them explicitly). Each of
# these is an `export ... $(brew --prefix ...)` line written *literally*
# into the rc file — the `brew --prefix` calls run fresh every time a new
# shell starts, not just once now, so they stay correct even if Homebrew's
# install paths ever change.
append_env_var "$RC_FILE" "opt/sqlite/bin" "export PATH=\"$(lt_homebrew_prefix)/opt/sqlite/bin:\$PATH\""
append_env_var "$RC_FILE" 'LDFLAGS.*openssl' "export LDFLAGS=\"-L\$(brew --prefix openssl)/lib -L\$(brew --prefix readline)/lib -L\$(brew --prefix sqlite3)/lib -L\$(brew --prefix zlib)/lib\""
append_env_var "$RC_FILE" 'CPPFLAGS.*openssl' "export CPPFLAGS=\"-I\$(brew --prefix openssl)/include -I\$(brew --prefix readline)/include -I\$(brew --prefix sqlite3)/include -I\$(brew --prefix zlib)/include\""
append_env_var "$RC_FILE" 'PKG_CONFIG_PATH.*openssl' "export PKG_CONFIG_PATH=\"\$(brew --prefix openssl)/lib/pkgconfig:\$(brew --prefix readline)/lib/pkgconfig:\$(brew --prefix sqlite3)/lib/pkgconfig\""

log "Shell config written to $RC_FILE."
