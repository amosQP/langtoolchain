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

RC_FILE="$(detect_rc_file)"
run touch "$RC_FILE"
log "Using rc file: $RC_FILE"

append_env_var "$RC_FILE" "ASDF_DATA_DIR" 'export ASDF_DATA_DIR="$HOME/.asdf"'
append_env_var "$RC_FILE" "ASDF_DATA_DIR/shims" 'export PATH="$ASDF_DATA_DIR/shims:$PATH"'

# Java home hook — pick the variant matching the detected shell
case "$RC_FILE" in
  *.zshrc) JAVA_HOOK="set-java-home.zsh" ;;
  *)       JAVA_HOOK="set-java-home.bash" ;;
esac
append_env_var "$RC_FILE" "$JAVA_HOOK" ". \$HOME/.asdf/plugins/java/$JAVA_HOOK"

# Python build flags (openssl/readline/sqlite3/zlib are keg-only, so the
# compiler can't find them unless we point at them explicitly)
append_env_var "$RC_FILE" "opt/sqlite/bin" 'export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"'
append_env_var "$RC_FILE" 'LDFLAGS.*openssl' "export LDFLAGS=\"-L\$(brew --prefix openssl)/lib -L\$(brew --prefix readline)/lib -L\$(brew --prefix sqlite3)/lib -L\$(brew --prefix zlib)/lib\""
append_env_var "$RC_FILE" 'CPPFLAGS.*openssl' "export CPPFLAGS=\"-I\$(brew --prefix openssl)/include -I\$(brew --prefix readline)/include -I\$(brew --prefix sqlite3)/include -I\$(brew --prefix zlib)/include\""
append_env_var "$RC_FILE" 'PKG_CONFIG_PATH.*openssl' "export PKG_CONFIG_PATH=\"\$(brew --prefix openssl)/lib/pkgconfig:\$(brew --prefix readline)/lib/pkgconfig:\$(brew --prefix sqlite3)/lib/pkgconfig\""

log "Shell config written to $RC_FILE."
