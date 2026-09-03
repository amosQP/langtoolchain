#!/usr/bin/env sh
# Shared utilities sourced by the phase scripts under scripts/install/ and
# scripts/uninstall/. Pure functions only — sourcing this file has no side
# effects, so any phase script can source it standalone, in any order,
# without depending on another phase script having run first.
#
# Written for POSIX sh (TASK-71/72) — no [[ ]], no arrays, no BASH_REMATCH,
# no other bash-only syntax. `local` is the one non-POSIX-standard
# exception kept deliberately (see TASK-71): it's supported by every real
# POSIX-compliant shell this tool targets (dash included), and dropping it
# would mean every function falls back to polluting the global namespace.

# DRY_RUN is exported by main.sh before it launches each phase script as a
# child process. `:-false` makes this file safe to source on its own too
# (e.g. while testing a single phase by hand) — it just defaults to "do it
# for real".
DRY_RUN="${DRY_RUN:-false}"

# ---- Shared constants ----
# Literal values (paths, filenames, package lists, rc-file search/write
# patterns) that used to be typed independently into multiple phase
# scripts, which let them silently drift out of sync with each other (see
# e.g. the Intel-Mac sqlite PATH bug fixed alongside TASK-61, or the
# BSD-sed java-hook bug fixed by TASK-56). Each entry below is its own
# clearly-separated block so another branch adding one more entry here
# merges cleanly. This section is data only — it holds no control flow,
# and no phase script's own logic is meant to move here.

# Homebrew formulas needed to compile Python's (and friends') C extensions.
# Single source of truth for scripts/install/03_install_system_deps.sh,
# scripts/uninstall/04_remove_system_deps.sh, and ensure_build_flags() below
# (which only needs the openssl/readline/sqlite3/zlib subset — see there).
LT_BUILD_DEPS="openssl readline sqlite3 xz zlib tcl-tk"

# lt_homebrew_prefix (TASK-61): prints Homebrew's install prefix for the
# CPU architecture this script is running on right now. Apple Silicon and
# Intel Macs use two different fixed Homebrew locations; every script that
# needs a Homebrew-rooted path (the brew binary itself, a keg-only
# formula's bin dir, etc.) should compute it by calling this function
# instead of re-typing its own `uname -m` case — that duplication is what
# let the sqlite PATH line go stale to an Apple-Silicon-only path on Intel
# Macs.
lt_homebrew_prefix() {
  case "$(uname -m)" in
    arm64) echo "/opt/homebrew" ;;  # Apple Silicon
    *)     echo "/usr/local" ;;     # Intel
  esac
}

# LT_ASDF_DATA_DIR_NAME / LT_ASDF_DATA_DIR_DEFAULT (TASK-62): asdf's own
# default data directory when the caller's environment hasn't set
# ASDF_DATA_DIR — this is where every asdf-managed download, plugin, and
# shim actually lives. Split into a bare directory NAME and the expanded
# DEFAULT path so both shapes are available: scripts doing real filesystem
# work (ensure_asdf_on_path's fallback, uninstall's delete target) want the
# expanded absolute path; a script writing a line into an rc file for a
# *future* shell to evaluate wants the bare name so it can keep `$HOME`
# itself literal (unexpanded) in what gets written, exactly like the
# original code did — resolving $HOME at write time instead would bake in
# whatever $HOME happened to be during install rather than at each future
# shell's own startup.
LT_ASDF_DATA_DIR_NAME=".asdf"
LT_ASDF_DATA_DIR_DEFAULT="$HOME/$LT_ASDF_DATA_DIR_NAME"

# lt_asdf_data_dir: prints the effective asdf data directory — a live
# ASDF_DATA_DIR override if the caller's environment already has one, else
# the default above. Split out of ensure_asdf_on_path() (which also exports
# it and touches PATH) so callers that only need the *value* — teardown
# checks that must NOT put asdf back on PATH — don't have to re-type the
# same "${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}" fallback themselves.
lt_asdf_data_dir() {
  echo "${ASDF_DATA_DIR:-$LT_ASDF_DATA_DIR_DEFAULT}"
}

# LT_RC_FILE_ZSH / LT_RC_FILE_BASH / LT_RC_FILE_BASH_INTERACTIVE /
# LT_KNOWN_RC_FILES (TASK-66): the rc filenames (bare, relative to $HOME)
# this tool knows how to write into or clean up.
#
# detect_rc_file() (below) picks exactly ONE of these at install time,
# based on the current $SHELL — the installer only ever writes into the rc
# file matching whichever shell is actually running it.
#
# uninstall/03_clean_env_vars.sh instead sweeps ALL of LT_KNOWN_RC_FILES:
# the $SHELL active when uninstall runs isn't necessarily the same one that
# was active when install ran, so it can't assume which single file was
# written to and has to check every rc file this tool has ever been able to
# write. This install-picks-one vs. uninstall-sweeps-all asymmetry is
# intentional, not an oversight.
LT_RC_FILE_ZSH=".zshrc"
LT_RC_FILE_BASH=".bash_profile"          # macOS Terminal runs login shells
LT_RC_FILE_BASH_INTERACTIVE=".bashrc"    # never picked by detect_rc_file; swept by uninstall only
LT_KNOWN_RC_FILES="$LT_RC_FILE_ZSH $LT_RC_FILE_BASH $LT_RC_FILE_BASH_INTERACTIVE"

# LT_LOCAL_PINS_FILE_NAME (TASK-83): bare filename, under $ASDF_DATA_DIR, of
# the registry 06_set_globals.sh appends a directory to every time it pins
# versions LOCALLY (never globally) to that directory. 01_uninstall_runtimes.sh
# reads it back so a runtime version only ever pinned inside some project
# directory (never in the global ~/.tool-versions) still gets asdf-uninstalled.
# Deliberately lives under $ASDF_DATA_DIR: 05_purge_asdf_core.sh's `rm -rf
# $ASDF_DATA_DIR` deletes this file too, so there's nothing extra to clean up.
LT_LOCAL_PINS_FILE_NAME="langtoolchain-local-pins"

# LT_LOCK_DIR (TASK-84): a single lock shared by install/main.sh and
# uninstall/main.sh, so an install can never run concurrently with another
# install, an uninstall, or itself — all of them mutate the same asdf/
# Homebrew state. `mkdir` is used as the lock primitive (not `flock`, which
# macOS doesn't ship) because directory creation is atomic on every real
# filesystem: at most one concurrent `mkdir LT_LOCK_DIR` can succeed.
# `${LT_LOCK_DIR:-default}`, same override pattern as ASDF_DATA_DIR below:
# lets a test (or an unusual caller) point this somewhere other than the
# real shared path without that being a special case in acquire_lock itself.
LT_LOCK_DIR="${LT_LOCK_DIR:-${TMPDIR:-/tmp}/langtoolchain.lock}"

# LT_REPORT_FILE (m-10/TASK-107): a human-readable audit trail of every
# real change install/uninstall made - what got installed/removed/modified
# and where. Deliberately under $HOME directly, not $ASDF_DATA_DIR (unlike
# LT_LOCAL_PINS_FILE_NAME above) - a `rm -rf $ASDF_DATA_DIR` during
# uninstall would otherwise erase the very history someone might want to
# check right before/after running it. Override-able like LT_LOCK_DIR, so
# tests can point it at a scratch file instead of a real $HOME.
LT_REPORT_FILE="${LT_REPORT_FILE:-$HOME/.langtoolchain-report.log}"

# lt_report <action> <detail>: appends one line to LT_REPORT_FILE. Skipped
# under DRY_RUN by design - a preview run didn't actually change anything,
# so it has nothing real to add to the audit trail.
lt_report() {
  [ "$DRY_RUN" = "true" ] && return
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" "$2" >> "$LT_REPORT_FILE"
}

# LT_PRIOR_STATE_FILE (m-13/TASK-123, decision-6): records whether asdf/its
# data dir/any plugins already existed on this machine BEFORE this tool
# touched anything, so uninstall (TASK-124) can avoid deleting state it
# didn't create. Deliberately a separate file from LT_REPORT_FILE, not
# just another line in it: that one is a human-readable audit log
# (lt_report's timestamped lines); this one is parsed by uninstall to make
# an actual delete/skip decision, so it needs a stable, parse-only format
# (see lt_snapshot_prior_asdf_state/lt_prior_state_get below) instead of a
# log line's free-text "detail" field. Same $HOME-not-$ASDF_DATA_DIR
# placement as LT_REPORT_FILE and for the identical reason: a `rm -rf
# $ASDF_DATA_DIR` during uninstall must never delete the very file
# uninstall is about to consult to decide whether to run that rm -rf.
LT_PRIOR_STATE_FILE="${LT_PRIOR_STATE_FILE:-$HOME/.langtoolchain-prior-asdf-state}"

# lt_snapshot_prior_asdf_state: writes LT_PRIOR_STATE_FILE with whether asdf
# (brew list asdf), its data directory (lt_asdf_data_dir), and any asdf
# plugins already existed, as simple `key=value` lines - not the
# lt_report()-style timestamped log format, since this file's only reader is
# uninstall's own conditional logic (TASK-124.1), not a human. See decision-6
# for the full format writeup.
#
# Must run before ANY phase that could itself install asdf or create its
# data dir (01_bootstrap_asdf.sh) - callers are responsible for that
# ordering (install/main.sh calls this right after language selection,
# before the phase loop starts).
#
# Only ever writes once: if LT_PRIOR_STATE_FILE already exists, a later
# call is necessarily a re-run of install (Ctrl-C recovery, adding more
# languages, etc.) where asdf/its data dir may now contain state THIS tool
# itself created in an earlier run - overwriting the file at that point
# would corrupt the "before this tool touched anything" baseline uninstall
# depends on.
lt_snapshot_prior_asdf_state() {
  [ "$DRY_RUN" = "true" ] && return
  [ -f "$LT_PRIOR_STATE_FILE" ] && return

  # `brew list asdf` below needs `brew` resolvable in THIS process - see
  # ensure_brew_on_path's own comment for why that isn't automatic.
  ensure_brew_on_path

  local asdf_preexisting=false data_dir_preexisting=false plugins="" data_dir
  data_dir="$(lt_asdf_data_dir)"

  brew list asdf >/dev/null 2>&1 && asdf_preexisting=true
  [ -d "$data_dir" ] && data_dir_preexisting=true

  # Only attempt to list plugins when the asdf binary is actually
  # resolvable - matches the task's "asdf 자체가 없으면 생략" requirement
  # instead of letting a missing-command error leak into the snapshot.
  if command -v asdf >/dev/null 2>&1; then
    plugins="$(asdf plugin list 2>/dev/null | tr '\n' ' ' | sed 's/ *$//')"
  fi

  {
    printf 'asdf_preexisting=%s\n' "$asdf_preexisting"
    printf 'asdf_data_dir=%s\n' "$data_dir"
    printf 'asdf_data_dir_preexisting=%s\n' "$data_dir_preexisting"
    printf 'asdf_plugins_preexisting=%s\n' "$plugins"
  } > "$LT_PRIOR_STATE_FILE"
}

# lt_prior_state_get <key>: prints the value for <key> from
# LT_PRIOR_STATE_FILE. Fails (nothing printed, exit 1) when the file
# doesn't exist at all OR has no such key - callers (TASK-124.1) must treat
# that failure as "unknown", never silently coerce it to "false", since an
# absent snapshot is exactly the "installed before this feature existed"
# case decision-6 calls out. Deliberately grep+cut, not `.`/`eval` on the
# file - a plain key=value read doesn't need a full shell eval, and this
# avoids that risk entirely even though this file is only ever written by
# this tool itself.
lt_prior_state_get() {
  local key="$1" line
  [ -f "$LT_PRIOR_STATE_FILE" ] || return 1
  line="$(grep "^${key}=" "$LT_PRIOR_STATE_FILE" 2>/dev/null | head -n 1)"
  [ -n "$line" ] || return 1
  printf '%s\n' "${line#*=}"
}

# lt_env_var_defs [java_hook_file] (TASK-64): prints one line per rc-file
# entry this tool's installer manages, formatted
# "<search-pattern>|||<placement>|||<line-to-write>" (triple-pipe
# separators, since none of the fields contain them). Bash 3.2 has no
# associative arrays, so this is a flat list of delimited lines, meant to
# be read with `while IFS= read -r def; do ... done < <(lt_env_var_defs
# ...)` — the same shape each_tool() already uses for .tool-versions
# lines, just with a different separator since these lines contain spaces
# of their own.
#
# install/04_configure_shell_env.sh writes each <line-to-write>, guarded
# by <search-pattern>, calling prepend_env_var or append_env_var depending
# on <placement> ("prepend" or "append") — the placement decision lives
# here as data, not as a string the caller has to recognize, so it can't
# go stale independently of the pattern it applies to.
# uninstall/03_clean_env_vars.sh only needs the <search-pattern> field —
# it turns each one into a `sed -E -e '/pattern/d'` expression. Both read
# from this one function instead of each independently retyping the same
# patterns — that exact kind of drift is what caused TASK-56 (BSD sed
# never actually deleting the java-hook line, because uninstall's own copy
# of the pattern used a GNU-only regex extension the install side never
# had to match against). To add a new rc line, add one entry here; both
# install and uninstall pick it up automatically.
#
# The java-hook line's content depends on which shell's variant is in use
# (only install knows this, from the rc file it picked), so the caller
# passes it in as $1; uninstall doesn't pass anything, since it only ever
# reads the search-pattern field of that entry, never the content.
#
# "brew shellenv" is the only "prepend" entry — it must land ahead of the
# asdf shim PATH line, or a same-named Homebrew formula could shadow the
# asdf shim (see prepend_env_var's own comment). Everything else appends.
lt_env_var_defs() {
  local java_hook_file="${1:-}"
  local homebrew_prefix
  homebrew_prefix="$(lt_homebrew_prefix)"
  printf '%s\n' \
    "brew shellenv|||prepend|||eval \"\$($homebrew_prefix/bin/brew shellenv)\"" \
    "export ASDF_DATA_DIR=|||append|||export ASDF_DATA_DIR=\"\$HOME/$LT_ASDF_DATA_DIR_NAME\"" \
    "ASDF_DATA_DIR/shims|||append|||export PATH=\"\$ASDF_DATA_DIR/shims:\$PATH\"" \
    "set-java-home\.|||append|||. \$HOME/$LT_ASDF_DATA_DIR_NAME/plugins/java/$java_hook_file" \
    "opt/sqlite/bin|||append|||export PATH=\"$homebrew_prefix/opt/sqlite/bin:\$PATH\"" \
    "LDFLAGS.*openssl|||append|||export LDFLAGS=\"-L\$(brew --prefix openssl)/lib -L\$(brew --prefix readline)/lib -L\$(brew --prefix sqlite3)/lib -L\$(brew --prefix zlib)/lib\"" \
    "CPPFLAGS.*openssl|||append|||export CPPFLAGS=\"-I\$(brew --prefix openssl)/include -I\$(brew --prefix readline)/include -I\$(brew --prefix sqlite3)/include -I\$(brew --prefix zlib)/include\"" \
    "PKG_CONFIG_PATH.*openssl|||append|||export PKG_CONFIG_PATH=\"\$(brew --prefix openssl)/lib/pkgconfig:\$(brew --prefix readline)/lib/pkgconfig:\$(brew --prefix sqlite3)/lib/pkgconfig\""
}

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
  if [ "$DRY_RUN" = "true" ]; then
    printf '  + %s\n' "$*"
  else
    # "$@" preserves each argument's word boundaries/quoting exactly as the
    # caller passed them — unlike "$*", this is safe for arguments with
    # spaces.
    "$@"
  fi
}

# retry <max_attempts> <delay_seconds> <cmd...> (TASK-88): runs <cmd...>,
# and if it fails, retries with exponential backoff (delay doubles each
# time) up to <max_attempts> total attempts. Meant for genuinely transient
# failures (a network blip mid-download) — not a substitute for fixing a
# real error, which is why it still returns failure (not `|| true`) once
# attempts are exhausted, so the caller decides what that means.
#
# Compose with run(): `retry 3 5 run asdf install "$plugin" "$version"`.
# Under DRY_RUN, run() prints and returns success on the first call, so
# retry's own loop exits immediately too — no repeated dry-run output.
retry() {
  local max_attempts="$1" delay="$2" attempt=1
  shift 2
  while true; do
    if "$@"; then
      return 0
    fi
    if [ "$attempt" -ge "$max_attempts" ]; then
      return 1
    fi
    log "  (attempt $attempt/$max_attempts failed, retrying in ${delay}s...)"
    sleep "$delay"
    attempt=$((attempt + 1))
    delay=$((delay * 2))
  done
}

# ensure_disk_space <min_gb> (TASK-91): dies with a clear message if the
# filesystem containing $HOME has less than <min_gb> GB free. A best-effort
# up-front check, not a guarantee — a specific runtime's download+compile
# could still fail on genuinely tight disk even after this passes.
# `df -Pk`: POSIX output format (portable across BSD and GNU df) in 1024-byte
# blocks, so dividing by 1024 twice gets whole GB without needing `-g` (a
# GNU-only flag BSD/macOS df doesn't have).
ensure_disk_space() {
  local min_gb="$1" available_kb available_gb
  available_kb="$(df -Pk "$HOME" | awk 'NR==2 {print $4}')"
  available_gb=$((available_kb / 1024 / 1024))
  if [ "$available_gb" -lt "$min_gb" ]; then
    die "Only ${available_gb}GB free on the filesystem containing \$HOME (need at least ${min_gb}GB for Homebrew + asdf runtime compiles). Free up space and try again."
  fi
}

# LT_CHILD_PID: the currently-running phase child process, if any — set by
# run_phase() below, read by handle_interrupt() so a trapped signal can
# kill it directly instead of leaving it to run to completion untouched.
LT_CHILD_PID=""

# run_phase <script>: runs a phase script and waits for it — but as a
# backgrounded job + `wait`, not a plain synchronous `sh "$script"` call.
# This matters for TASK-90: a signal for which a trap is registered does
# NOT interrupt a shell blocked on a plain foreground command's exit —
# POSIX shells only dispatch the trap once that command returns on its own,
# which for a multi-minute `asdf install` mid-compile means Ctrl-C/SIGTERM
# would sit unprocessed (and the lock unreleased) until the compile
# finishes naturally. `wait` is different: POSIX explicitly guarantees it
# returns early the moment a trapped signal arrives, letting the trap fire
# immediately. (Found via a real CI failure, not by inspection: the TASK-32
# "kill mid-install then re-run" job failed with "another install appears
# to be running" — the first run's lock was still held, uncollected, when
# the second one started, because main.sh hadn't processed its own SIGTERM
# yet.) Only the immediate child is targeted, not further descendants (e.g.
# `asdf install`'s own compiler subprocesses) — sufficient to make the
# *lock* release promptly, which is what re-running depends on; deeper
# orphans left briefly behind (if any) aren't this process's to manage.
# Returns the phase's own exit status (not just whatever the trailing
# `LT_CHILD_PID=""` assignment would return, which is always 0) so a
# failing phase under the caller's `set -eu` actually stops the run instead
# of being silently treated as success.
run_phase() {
  # Between backgrounding the child and capturing its PID there's a brief
  # window where handle_interrupt has nothing to kill yet: a signal landing
  # exactly there would see an empty LT_CHILD_PID, skip the kill, and still
  # exit 130 — freeing the lock while this phase's child keeps running
  # unsupervised, the very orphan-plus-early-unlock this function exists to
  # prevent. Ignoring INT/TERM for that instant closes the window: POSIX
  # signals aren't queued while ignored, so a signal delivered there is
  # simply dropped rather than deferred — worst case it takes a second
  # Ctrl-C, which beats leaking an orphaned child.
  trap '' INT TERM
  sh "$1" &
  LT_CHILD_PID=$!
  trap 'handle_interrupt' INT TERM
  local status=0
  wait "$LT_CHILD_PID" || status=$?
  LT_CHILD_PID=""
  return "$status"
}

# handle_interrupt (TASK-90): registered via `trap handle_interrupt INT
# TERM` in install/main.sh and uninstall/main.sh, right after acquire_lock.
# Without this, Ctrl-C just kills the script with no explanation of what
# state it's left in. Every phase script this tool runs is safe to re-run
# (each one checks "already present"/"already absent" before acting — see
# design principle 1 in readme.md), so the honest, reassuring answer really
# is "just run it again." Kills LT_CHILD_PID first (see run_phase above) so
# a phase mid-flight actually stops instead of continuing to completion
# untouched. `exit 130` (128+SIGINT, the conventional exit code for Ctrl-C)
# still triggers the separately-registered EXIT trap afterward — INT/TERM
# and EXIT are independent trap slots, so this doesn't clobber the
# lock-release/cleanup trap the way two traps on the SAME signal would.
handle_interrupt() {
  if [ -n "$LT_CHILD_PID" ]; then
    kill "$LT_CHILD_PID" 2>/dev/null || true
  fi
  log ""
  log "Interrupted. Anything already finished will be skipped on a re-run - just run the same command again to continue."
  exit 130
}

# lt_die_if_lock_held: reads $LT_LOCK_DIR/pid and dies with the "another
# instance is running" message if that PID is still alive. Shared by
# acquire_lock()'s two check points below (the initial mkdir failure and the
# stale-lock reclaim race) so the message/logic can't drift between them.
lt_die_if_lock_held() {
  local holder_pid=""
  [ -f "$LT_LOCK_DIR/pid" ] && holder_pid="$(cat "$LT_LOCK_DIR/pid" 2>/dev/null)"
  if [ -n "$holder_pid" ] && kill -0 "$holder_pid" 2>/dev/null; then
    die "Another langtoolchain install/uninstall (pid $holder_pid) appears to be running. If you're sure it isn't, remove $LT_LOCK_DIR and retry."
  fi
}

# acquire_lock (TASK-84): takes the exclusive lock at LT_LOCK_DIR so two
# install/uninstall runs can never mutate asdf/Homebrew state at the same
# time. `mkdir` either succeeds (lock acquired) or fails because the
# directory already exists (someone else holds it) — nothing in between, so
# this can't race. If it's already held, checks whether the PID recorded
# inside it is still alive (`kill -0`, POSIX-specified, sends no signal):
# a live PID means a real concurrent run, so this dies with a clear message;
# a dead PID means whatever held the lock crashed/was killed before its own
# `release_lock` trap could fire, so the stale lock is reclaimed instead of
# permanently blocking every future run. Caller must `trap 'release_lock'
# EXIT` (or fold it into an existing combined trap) right after calling this.
acquire_lock() {
  if ! mkdir "$LT_LOCK_DIR" 2>/dev/null; then
    lt_die_if_lock_held
    # Stale lock (holder died before its own release_lock trap could run):
    # reclaim it. Two processes can observe the same stale lock at the same
    # instant and both reach this point — `rm -rf` on an already-removed
    # directory is a silent no-op, so at most one of the two `mkdir`s right
    # after it actually succeeds. The loser re-checks who holds the lock
    # now instead of assuming the worst: if the winner just legitimately
    # took it, that's reported as a real concurrent run, not a mystery
    # "could not acquire" failure.
    rm -rf "$LT_LOCK_DIR" 2>/dev/null
    if ! mkdir "$LT_LOCK_DIR" 2>/dev/null; then
      lt_die_if_lock_held
      die "Could not acquire lock at $LT_LOCK_DIR"
    fi
  fi
  echo $$ > "$LT_LOCK_DIR/pid"
}

# release_lock: removes the lock directory. Safe to call even when no lock
# was ever acquired (e.g. acquire_lock itself just died) — rm -rf on a path
# that doesn't exist is a no-op, not an error.
release_lock() {
  rm -rf "$LT_LOCK_DIR"
}

# repo_root_from <path-to-a-file-inside-scripts/install-or-uninstall>:
# prints the repository root (two directories up from scripts/install/ or
# scripts/uninstall/). Each phase script calls this with its own $0 so it
# can find .tool-versions regardless of the caller's current working
# directory.
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
    zsh)  echo "$HOME/$LT_RC_FILE_ZSH" ;;
    bash) echo "$HOME/$LT_RC_FILE_BASH" ;;
    *)    echo "$HOME/$LT_RC_FILE_ZSH" ;;  # unknown shell: default to zsh (macOS's own default since Catalina)
  esac
}

# append_env_var <rc_file> <search> <line>: appends <line> to <rc_file>,
# unless <rc_file> already contains something matching the grep pattern
# <search> — so re-running the installer never duplicates a line.
append_env_var() {
  local rc_file="$1" search="$2" line="$3"
  if [ "$DRY_RUN" = "true" ]; then
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
  if [ "$DRY_RUN" = "true" ]; then
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
  export ASDF_DATA_DIR="$(lt_asdf_data_dir)"
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
  brew_bin="$(lt_homebrew_prefix)/bin"
  if [ -x "$brew_bin/brew" ]; then
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
#
# Of the full LT_BUILD_DEPS list, only these four (openssl, readline,
# sqlite3, zlib) actually need compiler/linker flags — xz and tcl-tk don't,
# so they're intentionally left out below.
ensure_build_flags() {
  # `brew --prefix` below needs `brew` itself resolvable first.
  ensure_brew_on_path
  # Declared and assigned separately (not inline inside the export) so a
  # failing `brew --prefix`/`lt_homebrew_prefix` (e.g. the formula somehow
  # isn't actually installed) trips `set -e` here instead of being silently
  # swallowed — `export LDFLAGS="...$(cmd)..."` always "succeeds" as a
  # command even if the command substitution inside it failed, masking the
  # real error and leaving LDFLAGS built from an empty/wrong path.
  local homebrew_prefix openssl_prefix readline_prefix sqlite_prefix zlib_prefix prefixes
  homebrew_prefix="$(lt_homebrew_prefix)"
  export PATH="$homebrew_prefix/opt/sqlite/bin:$PATH"
  # One `brew --prefix` call for all four formulas (each spawns brew's own
  # Ruby interpreter, so four separate calls means four avoidable startups)
  # instead of one call per formula. Order matches the arguments, one prefix
  # per line; `set --` (not `read`, which would eat the last line without a
  # trailing newline) re-splits that into positional params on newlines only,
  # same idiom used for SELECT_OPTS/SED_ARGS elsewhere in this codebase.
  prefixes="$(brew --prefix openssl readline sqlite3 zlib)"
  IFS="
"
  # shellcheck disable=SC2086
  set -- $prefixes
  unset IFS
  openssl_prefix="$1" readline_prefix="$2" sqlite_prefix="$3" zlib_prefix="$4"
  export LDFLAGS="-L$openssl_prefix/lib -L$readline_prefix/lib -L$sqlite_prefix/lib -L$zlib_prefix/lib"
  export CPPFLAGS="-I$openssl_prefix/include -I$readline_prefix/include -I$sqlite_prefix/include -I$zlib_prefix/include"
  export PKG_CONFIG_PATH="$openssl_prefix/lib/pkgconfig:$readline_prefix/lib/pkgconfig:$sqlite_prefix/lib/pkgconfig"
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

# lt_companion_for_plugin <asdf-plugin-name> (m-7/TASK-99; python/uv added
# m-12/TASK-121, decision-5): prints the space-separated companion
# plugin(s) this language commonly needs alongside it - a package/build
# manager the base language plugin does NOT already bundle. nodejs's asdf
# plugin installs a bare Node runtime with only npm, so pnpm is a genuinely
# separate, commonly-wanted install; java's plugin installs only a JDK with
# no build tool at all, so gradle is closer to required than optional for
# real projects; python's plugin installs a bare interpreter with only pip,
# so uv (decision-5: chosen over poetry - single-binary install fits this
# repo's asdf-plugin-per-tool model, and leads poetry in both ecosystem
# adoption and asdf plugin activity as of that decision) fills the same gap
# pnpm/gradle fill for their languages. rust and golang have no entry here
# on purpose, not by omission: asdf-rust bundles cargo and the golang
# plugin's `go` binary already includes modules/build tooling, so there's
# no equivalent "separate package manager" gap to fill for them. Same
# `case` pattern as binary_for_plugin() above, for the same bash-3.2-has-
# no-associative-arrays reason. Empty output means "no companion for this
# plugin" - callers must treat that as a valid, common case, not an error.
lt_companion_for_plugin() {
  case "$1" in
    nodejs) echo pnpm ;;
    java)   echo gradle ;;
    python) echo uv ;;
    *)      echo "" ;;
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

# version_core <version-string>: extracts the first X.Y[.Z] numeric version
# substring (e.g. asdf's "temurin-25.0.2+10.0.LTS" -> "25.0.2"). Prints
# nothing (and fails) if the string has no such pattern (e.g. the alias
# "lts"), so callers can skip a version comparison instead of false-warning.
#
# POSIX sh has no [[ =~ ]]/BASH_REMATCH, so this uses sed instead: strip
# every leading non-digit character (`[^0-9]*`, greedy but unable to eat
# into a digit, so it always stops at the *first* digit run — this is what
# gives leftmost-match behavior, same as the old regex), then capture an
# X.Y or X.Y.Z run and discard everything after it. Plain BRE (no -E), so
# this is portable to both BSD and GNU sed without needing -E.
version_core() {
  local result
  result="$(printf '%s\n' "$1" | sed -n 's/[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\(\.[0-9][0-9]*\)*\).*/\1/p')"
  [ -n "$result" ] || return 1
  printf '%s\n' "$result"
}

# LT_VERSION_FETCH_TIMEOUT (m-12/TASK-119): per-network-call timeout, in
# seconds, for lt_upstream_latest_version()'s curl/git calls below.
# Override-able like LT_LOCK_DIR/LT_REPORT_FILE elsewhere in this file, so
# a test can shrink it instead of waiting out a real timeout.
LT_VERSION_FETCH_TIMEOUT="${LT_VERSION_FETCH_TIMEOUT:-5}"

# lt_adoptium_arch: prints the CPU architecture name Adoptium's API expects
# (used by lt_upstream_latest_version's java case below) - different from
# lt_homebrew_prefix's own uname -m mapping only in spelling ("aarch64" vs
# "arm64"), so this can't just reuse that function.
lt_adoptium_arch() {
  case "$(uname -m)" in
    arm64) echo aarch64 ;;  # Apple Silicon
    *)     echo x64 ;;      # Intel
  esac
}

# lt_json_field <key> [value_prefix] (m-16/TASK-133): reads a JSON body
# from stdin and prints the string value of the first "<key>": "<value>"
# pair, quotes stripped. Factored out of lt_upstream_latest_version below,
# whose pnpm/gradle/golang/java/uv branches each inlined this same
# grep+head+sed sequence (pnpm/gradle were byte-for-byte identical; golang/
# java were prefix variants) - one place to fix the extraction now instead
# of five.
#
# value_prefix, if given, requires the matched value to literally start
# with it and strips it from the printed result - e.g. go.dev's
# "version":"go1.27.1" needs prefix "go" to yield "1.27.1". Omit it for a
# plain string field (pnpm/gradle/java/uv all pass no prefix here; java's
# own "temurin-" decoration is added by its caller afterward, since that
# prefix goes on the *output* rather than stripping one from the *input* -
# a different operation this helper doesn't need to know about).
#
# Same head -1/sed shape as the original inline code: no match still exits
# 0 with empty output (sed processes zero lines cleanly), matching how
# every existing call site/test already treats a missing field as "nothing
# printed", not a hard failure.
lt_json_field() {
  local key="$1" prefix="${2:-}"
  grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"${prefix}[^\"]*\"" | head -1 | sed -E "s/.*\"${prefix}([^\"]*)\"\$/\1/"
}

# lt_upstream_latest_version <plugin> (m-12/TASK-118 decision, decision-4):
# fetches this plugin's latest stable version straight from that language's
# own official distribution index/API - deliberately NOT via `asdf latest`/
# `asdf list all` (see decision-4: those require the plugin to already be
# added to asdf, which 00_select.sh can't guarantee at phase 0 - see
# ask_version()'s own comment in scripts/install/00_select.sh). Every
# branch below needs nothing but curl (or git, for python) and the network
# - no asdf, no plugin - so it's safe to call directly from phase 0.
#
# Prints the version string on success. Returns 1 (nothing printed) on any
# failure - missing curl, network/DNS failure, non-2xx response, empty or
# unparseable body - so callers must always have a static fallback ready
# (see lt_default_version below, the function every real call site uses).
#
# Same case-dispatch style as binary_for_plugin()/lt_companion_for_plugin()
# above, for the same bash-3.2-has-no-associative-arrays reason.
lt_upstream_latest_version() {
  # No up-front `command -v curl` guard here on purpose: every branch below
  # that needs curl (or git, for python) already chains `|| return 1` onto
  # its own call, which catches a missing binary (exit 127) exactly like
  # any other failure - a shared guard would also incorrectly gate the
  # nodejs branch (which shells out to nothing at all).
  local plugin="$1" body lts_major semver
  case "$plugin" in
    nodejs)
      # asdf-nodejs resolves the "lts" alias itself, fresh, at actual
      # `asdf install nodejs lts` time - a network call here would only
      # ever produce a snapshot that's already stale by the time asdf uses
      # it, so this passes the alias straight through instead of
      # pre-resolving it. (This is also why .tool-versions already carries
      # "lts", not a pinned number, for nodejs.)
      echo lts
      ;;
    pnpm)
      # npm registry - the same place asdf-pnpm's own installer downloads
      # pnpm from.
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://registry.npmjs.org/pnpm/latest' 2>/dev/null)" || return 1
      printf '%s\n' "$body" | lt_json_field version
      ;;
    gradle)
      # Gradle's own official "current version" API - a single value, no
      # rc/milestone noise to filter (unlike asdf-gradle's list-all).
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://services.gradle.org/versions/current' 2>/dev/null)" || return 1
      printf '%s\n' "$body" | lt_json_field version
      ;;
    golang)
      # go.dev's official download index - first array entry is the
      # current stable release.
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://go.dev/dl/?mode=json' 2>/dev/null)" || return 1
      printf '%s\n' "$body" | lt_json_field version go
      ;;
    rust)
      # Rust's official release channel manifest (TOML) - the [pkg.rust]
      # section's version field specifically, since the file also lists
      # cargo/rustfmt/etc.'s own versions under the same "version" key.
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://static.rust-lang.org/dist/channel-rust-stable.toml' 2>/dev/null)" || return 1
      printf '%s\n' "$body" | awk '/^\[pkg\.rust\]/{f=1; next} f && /^version/{print; exit}' | sed -E 's/version = "([0-9.]+).*/\1/'
      ;;
    python)
      # No official JSON index with a working "just the latest" server-side
      # filter (python.org's release API doesn't order/filter the way its
      # own docs suggest - checked directly, see TASK-118.1 notes) - cpython's
      # own tags are the next best official source. Tags mix final releases
      # (vX.Y.Z) with pre-releases (vX.Y.ZaN/bN/rcN); filter down to final
      # releases only, then sort each dotted field numerically (macOS's BSD
      # sort has no -V/version-sort, unlike GNU sort) and take the highest.
      body="$(git -c http.lowSpeedLimit=1000 -c http.lowSpeedTime="$LT_VERSION_FETCH_TIMEOUT" ls-remote --tags --refs https://github.com/python/cpython.git 2>/dev/null)" || return 1
      printf '%s\n' "$body" | awk '{print $2}' | sed -n 's#^refs/tags/v##p' | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1
      ;;
    java)
      # Two-step Eclipse Adoptium (Temurin) lookup: which major version is
      # the current LTS, then that major's latest GA JDK build for this
      # Mac's own architecture. The "semver" field comes back pre-formatted
      # exactly like asdf-java's own version strings (e.g.
      # "25.0.4+101.0.LTS"), so no reformatting is needed beyond prepending
      # "temurin-". os=mac is hardcoded - this repo is macOS-only.
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://api.adoptium.net/v3/info/available_releases' 2>/dev/null)" || return 1
      lts_major="$(printf '%s\n' "$body" | grep -o '"most_recent_lts"[[:space:]]*:[[:space:]]*[0-9]*' | grep -o '[0-9]*$')"
      [ -n "$lts_major" ] || return 1
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" "https://api.adoptium.net/v3/assets/latest/$lts_major/hotspot?vendor=eclipse&os=mac&image_type=jdk&architecture=$(lt_adoptium_arch)" 2>/dev/null)" || return 1
      semver="$(printf '%s\n' "$body" | lt_json_field semver)"
      if [ -n "$semver" ]; then
        printf 'temurin-%s\n' "$semver"
      fi
      ;;
    uv)
      # uv (m-12/TASK-121, decision-5's companion pick for python) has no
      # official JSON distribution index of its own (unlike the 7 languages
      # above, each with a dedicated official index/API) - GitHub's Releases
      # API is the fallback decision-4 already set aside for exactly this
      # case. "tag_name" is already bare (e.g. "0.12.9", no leading "v"),
      # matching asdf-uv's own version strings directly - no reformatting.
      body="$(curl -fsS --max-time "$LT_VERSION_FETCH_TIMEOUT" 'https://api.github.com/repos/astral-sh/uv/releases/latest' 2>/dev/null)" || return 1
      printf '%s\n' "$body" | lt_json_field tag_name
      ;;
    *)
      # Unknown plugin (e.g. this repo's own custom TOOL_VERSIONS_FILE users
      # could pass one this function has no case for): no source to fetch
      # from, so fail like any other lookup miss - callers fall back to the
      # static default.
      return 1
      ;;
  esac
}

# LT_VERSION_CACHE_FILE / LT_VERSION_CACHE_TTL (m-12/TASK-119.3): where
# lt_resolve_default_version below remembers a plugin's last successfully
# fetched upstream version, and how long (seconds) that memory stays fresh
# before the next call re-fetches instead of trusting it. Deliberately
# under $HOME directly, like LT_REPORT_FILE - not under $ASDF_DATA_DIR,
# since this cache's whole purpose (avoiding a repeat network round-trip
# across nearby installer runs) has nothing to do with asdf's own state and
# shouldn't be wiped by `05_purge_asdf_core.sh`'s `rm -rf $ASDF_DATA_DIR`.
# Both override-able, same pattern as LT_LOCK_DIR/LT_REPORT_FILE, so a test
# can point this at a scratch file/short TTL instead of touching a real
# $HOME or waiting out a real day. 86400s = 24h: this is a personal,
# occasionally-run installer, not a CI job re-invoked every minute - daily
# freshness is already more current than the static .tool-versions it
# replaces, without re-hitting every upstream API on every single run
# during, say, a single afternoon of repeated installs while testing.
LT_VERSION_CACHE_FILE="${LT_VERSION_CACHE_FILE:-$HOME/.langtoolchain-version-cache}"
LT_VERSION_CACHE_TTL="${LT_VERSION_CACHE_TTL:-86400}"

# lt_cached_version_lookup <plugin>: prints <plugin>'s cached version if
# LT_VERSION_CACHE_FILE has a line for it written within the last
# LT_VERSION_CACHE_TTL seconds; fails (nothing printed) on a cache miss -
# no file yet, no line for this plugin, or a line older than the TTL.
# Internal to this file - lt_resolve_default_version below is the only
# caller, and the only supported way to read this cache.
#
# Cache line format: "<plugin>|||<unix-epoch>|||<version>", one per plugin,
# same triple-pipe-delimited shape lt_env_var_defs() above already uses for
# its own multi-field lines (none of these fields can contain "|||").
lt_cached_version_lookup() {
  local plugin="$1" line ts version now
  [ -f "$LT_VERSION_CACHE_FILE" ] || return 1
  # grep finding nothing here is a normal cache miss, not an error - `|| true`
  # keeps that from tripping callers running under `set -e`.
  line="$(grep "^$plugin|||" "$LT_VERSION_CACHE_FILE" 2>/dev/null | tail -1)" || true
  [ -n "$line" ] || return 1
  ts="$(printf '%s\n' "$line" | awk -F'\\|\\|\\|' '{print $2}')"
  version="$(printf '%s\n' "$line" | awk -F'\\|\\|\\|' '{print $3}')"
  [ -n "$version" ] || return 1
  # A non-numeric ts (hand-edited/corrupted cache file - this cache is
  # never written with anything but a real `date +%s` epoch) would make the
  # arithmetic comparison below a hard shell error, not just a false
  # result - reject it as a miss instead of letting that abort the caller.
  case "$ts" in
    '' | *[!0-9]*) return 1 ;;
  esac
  now="$(date +%s)"
  [ $((now - ts)) -lt "$LT_VERSION_CACHE_TTL" ] || return 1
  printf '%s\n' "$version"
}

# lt_cache_version <plugin> <version>: (over)writes <plugin>'s line in
# LT_VERSION_CACHE_FILE with <version> and the current time, replacing any
# previous line for the same plugin (never appending a stale duplicate).
# Internal to this file, same as lt_cached_version_lookup above.
lt_cache_version() {
  local plugin="$1" version="$2" tmp
  tmp="$(mktemp)"
  if [ -f "$LT_VERSION_CACHE_FILE" ]; then
    # No existing line for this plugin is a normal case (first time it's
    # ever been cached), not an error - `|| true` so `set -e` callers don't
    # abort on grep's "found nothing" exit status.
    grep -v "^$plugin|||" "$LT_VERSION_CACHE_FILE" > "$tmp" 2>/dev/null || true
  else
    : > "$tmp"
  fi
  printf '%s|||%s|||%s\n' "$plugin" "$(date +%s)" "$version" >> "$tmp"
  mv "$tmp" "$LT_VERSION_CACHE_FILE"
}

# lt_resolve_default_version <plugin> <static-default> (m-12/TASK-119.2/
# TASK-119.3, decision-4): the actual call site scripts/install/
# 00_select.sh's ask_version() comment refers to. Order of preference:
#
#   1. a fresh (within LT_VERSION_CACHE_TTL) cached value - no network call
#      at all, so re-running the installer soon after a previous run (e.g.
#      while testing, or a `--local` install right after a global one)
#      doesn't re-hit every upstream API for versions it already just
#      fetched.
#   2. a live lt_upstream_latest_version() lookup - cached for next time on
#      success.
#   3. <static-default> (the .tool-versions value 00_select.sh already has
#      on hand) - whenever both of the above come up empty (offline,
#      rate-limited, timeout, unmapped plugin, or simply no cache yet and
#      the live lookup also failed).
#
# Callers never see an empty default, and a completely offline machine
# behaves exactly as it did before m-12: the static .tool-versions value,
# install proceeds unblocked.
lt_resolve_default_version() {
  local plugin="$1" static_default="$2" cached fetched
  cached="$(lt_cached_version_lookup "$plugin" 2>/dev/null)" || cached=""
  if [ -n "$cached" ]; then
    printf '%s\n' "$cached"
    return 0
  fi
  fetched="$(lt_upstream_latest_version "$plugin" 2>/dev/null)" || fetched=""
  if [ -n "$fetched" ]; then
    lt_cache_version "$plugin" "$fetched"
    printf '%s\n' "$fetched"
    return 0
  fi
  printf '%s\n' "$static_default"
}
