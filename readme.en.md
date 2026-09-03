<div align="center">

# 🧰 langtoolchain

**Install Node.js · Java · Python · Rust · Go compilers on macOS with one command**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS-000000?logo=apple&logoColor=white)](#-prerequisites)
[![Shell](https://img.shields.io/badge/shell-POSIX%20sh-4EAA25)](#-contributing)
[![Powered by asdf](https://img.shields.io/badge/powered%20by-asdf-F16436)](https://asdf-vm.com)

[한국어](readme.md) | **English**

No `git clone`, no manual setup. Paste one line into your terminal and you're done.

</div>

<br>

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | sh
```

<br>

> ⚠️ **macOS-only, personal tooling.** There's no plan to support Linux/Windows (including
> WSL), and this wasn't built as a general-purpose production tool — it's shaped around my
> own Mac workflow. No guarantees about behavior on other setups or use cases.

## Why this exists

Every new Mac meant reinstalling Homebrew and asdf, adding plugins, and fixing `.zshrc` by hand — the same grind every time. I got tired of it, so I built this. **Now it's one line.** Homebrew, asdf, language selection, shell config — all automatic.

- 🍺 **Works without Homebrew** — installs it via the official script if missing (you only type your sudo password)
- ☑️ **Checkbox-style interactive install** — confirm install/skip and version per language
- 🌐 **Full `curl | sh` support** — clones the remote repo into a scratch dir on its own if nothing's local
- 🌍 **Global or per-directory version pinning** — set a system-wide default, or scope it to one project
- 🔙 **Clean uninstall** — everything it installed can be undone (backups kept as `.bak`)
- 🖥️ **POSIX sh compatible** — runs as-is under macOS's default shell (`/bin/sh`), no bash-only syntax

<br>

## Table of Contents

- [Quick Start](#-quick-start)
- [Prerequisites](#-prerequisites)
- [What Gets Installed / Removed](#-what-gets-installed--removed)
- [Known Limitations / Technical Limitations](#-known-limitations--technical-limitations)
- [Contributing](#-contributing)
- [License](#-license)

<br>

## 🚀 Quick Start

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/install.sh | sh
```

If you already have it cloned locally:

```zsh
git clone https://github.com/amosQP/langtoolchain.git && cd langtoolchain
./install.sh
```

Confirms install/skip and version per language (↑/↓ + Enter, or a digit key to jump straight to an
option), then asks once more before starting. Each answer collapses in place into a single confirmed
line as you go — here's what the actual screen looks like.

```text
== Select languages to install ==

✔ Install nodejs (node)? Yes
✔ Version: lts (default)
✔ Also install pnpm (companion to nodejs)? Yes
✔ Version: 10.33.0 (default)

✔ Install java (java)? No
...
== Install list ==
  nodejs  lts
  pnpm    10.33.0
  python  3.12.13
  rust    1.94.0
  golang  1.26.1

✔ Pin these versions: Globally
✔ Install these? Yes
```

> The last prompt decides whether the versions you just picked get pinned globally
> (`~/.tool-versions`) or only in the current directory — asdf's own standard mechanism (the same
> idea as nvm's `.nvmrc`, just unified into one `.tool-versions` format regardless of language).
>
> A companion tool (pnpm/gradle) is only offered right after you accept its parent language
> (nodejs/java) — in the example above, declining java with `n` means the gradle question never
> shows up at all.

<details>
<summary><b>Flags</b> (pass them as <code>curl | sh -s -- &lt;flags&gt;</code>)</summary>
<br>

| Flag | Applies to | Behavior |
|---|---|---|
| `--all` | install | Skip the language picker, install everything in `.tool-versions` |
| `--yes` | install / uninstall | Skip the final confirmation prompt |
| `--dry-run` | install / uninstall | Change nothing — just print what would happen |
| `--local` / `--local=<dir>` | install | Pin versions to the current (or given) directory instead of globally |

These combine freely: `curl ... | sh -s -- --all --yes --dry-run` works.
With no controlling terminal (CI, etc.), it automatically behaves like `--all` — it never hangs waiting for input.

</details>

<br>

## 📋 Prerequisites

| Needed | If missing |
|---|---|
| macOS | This tool is macOS-only |
| `git` (for the remote installer) | Ships with the Xcode Command Line Tools |
| ~~Homebrew~~ | The installer installs it for you (you'll still be prompted for your sudo password) |
| ~~asdf~~ | The installer installs it via `brew install asdf` |

<br>

## 📦 What Gets Installed / Removed

The default languages/versions from `.tool-versions` — toggle each one on/off or override its version
on the install screen. Companion tools (pnpm/gradle) are optional and only offered when you install
their parent language.

| Language / companion | Default version |
|---|---|
| 🟩 Node.js | `lts` |
| &nbsp;&nbsp;└ pnpm (companion) | `10.33.0` |
| ☕ Java (Temurin) | `temurin-25.0.2+10.0.LTS` |
| &nbsp;&nbsp;└ gradle (companion) | `9.4.1` |
| 🐍 Python | `3.12.13` |
| 🦀 Rust | `1.94.0` |
| 🐹 Go | `1.26.1` |

The Homebrew packages Python needs to compile (`openssl`, `readline`, `sqlite3`, `xz`, `zlib`, `tcl-tk`) are installed alongside it.

This tool only touches the languages above (+ companions) and the 6 Homebrew packages they need — it
never touches other packages already on your Mac or installed later via `brew install`, or asdf plugins
it didn't install itself, on either the install or the uninstall side. Uninstall checks the install-time
snapshot before removing anything asdf-related — both each individual plugin it didn't install itself
and the whole `~/.asdf/` data directory it still tries to purge along with `asdf` itself: **if
install-time evidence shows a given plugin, or `~/.asdf/` as a whole, already existed before langtoolchain
ever ran (or that can't be confirmed), it skips deleting that and just warns instead** — unlike the old
behavior, which wiped everything unconditionally along with any other asdf plugins you had.

> **⚠️ Behavior change (m-13)**: if you installed with a version of this tool from before this change and
> have only updated since, there's no install-time snapshot for uninstall to check — so uninstall now
> skips removing individual asdf plugins as well as deleting `~/.asdf/` entirely, both by default for
> safety (no evidence either way means "don't delete"). If you want a full clean including every runtime
> langtoolchain installed, run uninstall and then remove it yourself as it instructs: `rm -rf ~/.asdf`.

```zsh
curl -fsSL https://raw.githubusercontent.com/amosQP/langtoolchain/main/uninstall.sh | sh
```

Asks for confirmation once before running (skip with `--yes`); `--dry-run` is supported the same way.
After installing/uninstalling, open a new shell session with `exec $SHELL` so cached state like PATH is
fully gone.

<br>

## 🧭 Known Limitations / Technical Limitations

### Scope limitations

- **macOS only** — no Linux/Windows support.
- **Fixed to 5 languages** — adding another language means editing code; there's no way to freely add arbitrary asdf plugins the way raw asdf allows.
- **Companion tools exist only for nodejs/java** — pnpm (nodejs) and gradle (java) are the only ones; Rust/Go don't need one (cargo/the module system are already built in), and Python's ecosystem (`poetry`, `uv`, etc.) hasn't been evaluated.
- **Some features go beyond the core mission ("install compilers")** — global/local version pinning and the interactive picker are really a wrapper around asdf's own version management. This was reviewed once and deliberately kept as-is; no plan to trim it.
- **No support for tooling outside Homebrew/asdf** — MacPorts (`/opt/local`) doesn't overlap paths, so no file conflicts, but a same-named binary it installs still wins if its rc entry loads later. `mise`, which reads `.tool-versions` directly and activates via its own PATH hook, is the more realistic risk — if it loads after langtoolchain in the rc file, it can silently shadow the asdf shim. Neither case is detected or warned about.

### Download/install chain trust boundary (m-11)

Draws a line between what this repo actually verifies and what it delegates to Homebrew/asdf
or simply can't reach. See
[docs/download-points-inventory.md](docs/download-points-inventory.md) for the full per-point
breakdown (file:line, current verification level), and
[docs/download-integrity-techniques.md](docs/download-integrity-techniques.md) for the survey
of verification techniques this was chosen from.

**Points this repo verifies directly**

| Point | How |
|---|---|
| `install.sh`/`uninstall.sh`'s self-clone | Pinned to a fixed commit SHA instead of a floating branch — a force-pushed branch can't change what a pinned commit fetches |
| Homebrew's official install script (`curl \| bash`) | Pinned to a fixed commit + this project's own precomputed SHA-256 checksum, checked right after fetch — a mismatch refuses to execute |

**Delegated / out of this repo's control**

| Point | Delegated to / why it's out of reach |
|---|---|
| `brew install asdf`, `brew install <the 6 system deps>` | Homebrew's own bottle signing/checksum chain |
| `asdf plugin add` (asdf-nodejs/asdf-python/etc. plugin sources) | asdf's CLI (0.20.0) has no way to pin a commit — reviewed and deliberately left unpinned; every install run refreshes already-added plugins to each plugin repo's latest HEAD |
| `asdf install` (the actual language runtime download) | Internal to each asdf plugin — this repo has no hook into it |

**Explicitly out of scope: a full takeover of the GitHub repo/account itself.** If an attacker
fully controls the repo or maintainer account, they can rewrite the pinned commit SHA baked
into install.sh too — no amount of self-referential pinning defends against that. That's
GitHub's own account-level controls (branch protection, signed-commit requirements, 2FA), not
something a shell installer can solve, so it's deliberately kept outside this milestone's scope.

### Testing limitations

- **The local shellspec suite never touches a real Homebrew/asdf** — all 168 examples in `spec/` either mock `brew`/`asdf` or run under `DRY_RUN=true`, since a real compile/install is slow and would pollute a dev machine. So "does this actually install" isn't something the local suite proves — `.github/workflows/e2e-verify.yml` (GitHub-hosted macOS runners, arm64 + Intel) is the only real-hardware path, and it only auto-runs on push/PR to `main` when `scripts/**`/`install.sh`/`uninstall.sh`/`.tool-versions` change (everything else needs a manual `workflow_dispatch`).
- **The arrow-key TUI has only been verified against standard terminals** — `lt_arrow_menu()` reads raw mode via `stty`/`dd`, and has been checked against a real pty driven by `expect` and ordinary terminal apps, but not against every terminal emulator, multiplexer (tmux/screen), or SSH-relayed session — anything sending non-standard key sequences outside the plain 3-byte ANSI escape (`ESC [ A/B`) this relies on could behave unexpectedly.
- **The "default" `curl | sh` remote-clone path (the real GitHub target) is hard to reproduce locally** — the override path via `LANGTOOLCHAIN_REPO_URL`/`LANGTOOLCHAIN_BRANCH` (pointing at a fork or another branch) is covered locally as of TASK-117.6 by `spec/repo_override_spec.sh` against a throwaway local bare repo (`file://`), including the pinned-fetch mechanism's exact-ref behavior. What's still not covered locally is the no-override default path (the pinned commit SHA, against the real GitHub repo) — that's only exercised by a real `curl | sh` run against this actual repo and by `.github/workflows/e2e-verify.yml`'s `no-git-curl-pipe` job (which does pull the real `main` raw file from GitHub).

### Worth revisiting

- Companion-tool support for the Python ecosystem (`pip` already ships with asdf-python, but `poetry`/`uv` haven't been considered).
- Detection/warning logic for competing toolchains like MacPorts or mise (currently documented only, nothing automatic).
- Linux support — not currently planned, but if it ever happens, the macOS-only Homebrew path logic and the rc-file list are the first things that would need rethinking.

<br>

## 🤝 Contributing

- To change languages/versions, edit `.tool-versions` — just one line.
- Each install/uninstall step lives under `scripts/install/`, `scripts/uninstall/`, one responsibility per file, and every phase runs standalone too: `DRY_RUN=true sh scripts/install/05_install_runtimes.sh`
- After changing code: `shellcheck -s sh` → `dash -n` (macOS's default `/bin/sh` is bash in posix mode, lenient enough to miss real POSIX violations) → `shellspec`/`shellspec --shell dash` for the `spec/` suite.
- Style rules (indentation, naming, quoting, etc.) live in [docs/shell-style-guide.md](docs/shell-style-guide.md) — a Google Shell Style Guide baseline adapted for this repo's POSIX sh constraint.
- To confirm the whole flow changes nothing: `./install.sh --dry-run --all --yes`, `./uninstall.sh --dry-run --yes`
- Real-hardware scenarios (Homebrew bootstrap, Intel Mac, etc.) run via `.github/workflows/e2e-verify.yml` — it auto-runs on push/PR to `main` when `scripts/**`/`install.sh`/`uninstall.sh`/`.tool-versions` change, and can otherwise be triggered manually with `workflow_dispatch`. Runs on GitHub-hosted macOS runners (arm64 + Intel) — free on this public repo.

<br>

## 📝 License

<div align="center">

[MIT](https://opensource.org/licenses/MIT) — free for anyone to use and modify. (This repo's [LICENSE](LICENSE) file has the same text.)

Made with 🧉 by [amosQP](https://github.com/amosQP)

</div>
