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

# Java home hook — pick the variant matching the detected shell (the
# asdf-java plugin ships both; sourcing the wrong one would just silently
# do nothing in that shell). This choice depends on which rc file we're
# writing to, so it's made here and handed to lib.sh's lt_env_var_defs()
# rather than lib.sh guessing it.
case "$RC_FILE" in
  *.zshrc) JAVA_HOOK="set-java-home.zsh" ;;
  *)       JAVA_HOOK="set-java-home.bash" ;;
esac

# Every rc-file line this installer manages — search pattern, placement
# (prepend/append), and the line to write — comes from this single shared
# definition (see lib.sh's lt_env_var_defs for why). Which lines prepend
# vs. append is decided there, as data, not by matching text here.
while IFS= read -r def; do
  search="${def%%|||*}"
  rest="${def#*|||}"
  placement="${rest%%|||*}"
  line="${rest#*|||}"
  case "$placement" in
    prepend) prepend_env_var "$RC_FILE" "$search" "$line" ;;
    *)       append_env_var "$RC_FILE" "$search" "$line" ;;
  esac
done < <(lt_env_var_defs "$JAVA_HOOK")

log "Shell config written to $RC_FILE."
