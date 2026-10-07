---
name: dotfiles-sync
description: "Inventory drift between the local macOS environment and this dotfiles repository, clean up what is no longer used, then reflect what remains back into the repository. Covers Homebrew formulae, casks and taps, mise tools, and config files edited directly through their symlinks."
when_to_use: "Use when reconciling the local machine with the dotfiles repo, e.g. 「ローカルの状態を取り込んで」「Brewfile を今の状態に合わせて」「入れっぱなしのものを整理したい」「dotfiles に反映できていないものは」, or 'sync my dotfiles with what's installed'. Do not use for a targeted edit such as adding or removing a single Brewfile line."
---

# Inventory and sync dotfiles

Find every mismatch between the local environment and the repository, decide per item whether to keep it (and record it in the repo) or uninstall it, and land the result as a single PR.

The goal is not to copy everything installed into the repository. Removing things that piled up locally and that the user no longer recognizes is part of the job. Never add a package to the Brewfile without checking what it is first.

## 1. Find the drift

Check the four kinds of drift below. The Brewfile management policy is in this repository's CLAUDE.md.

### Uncommitted changes

`fish/`, `mise/`, `.gitconfig`, `.gitignore_global` and similar files are loaded through symlinks, so edits made by installers or by hand show up as uncommitted changes in the working tree. Read them with `git status` and `git diff`, and identify what added each change (for example, a PATH line appended by an installer).

### Homebrew formulae

The baseline is `brew leaves --installed-on-request`. Formulae installed only as dependencies do not belong in the Brewfile.

- In leaves but not in the Brewfile: candidates to add
- In the Brewfile but not in leaves: already uninstalled, or now a dependency of something else
- In `brew list --installed-on-request` but not in leaves: installed explicitly, but also a dependency of another formula. Looking only at leaves misses these, and they drop out of the Brewfile once their dependent is removed. Check the dependents with `brew uses --installed <name>`

### Homebrew casks and taps

- Compare `brew list --cask` with the casks in the Brewfile. Different names can refer to the same cask; resolve them with `brew info --cask <name>` (for example, `linear-linear` is an old name for `linear`)
- A cask with the same name can exist in another tap. If `brew info --cask <name>` returns a different app, match by the Caskroom version and the tap-qualified name (`<user>/<tap>/<name>`), and write the fully qualified name in the Brewfile
- For each tap in `brew tap`, check whether any Brewfile entry uses it. A tap can linger after its formula moved to homebrew-core. Homebrew warns about untrusted taps

### Overlap between mise, Homebrew and bundled commands

Check that no tool is managed by both `mise/config.toml` and Homebrew. Also check for overlap with commands bundled in apps (for example, OrbStack ships a docker CLI, and Homebrew's `docker` shadows it on PATH). `which -a <command>` shows which one is used.

## 2. Ask about anything unfamiliar

For each candidate whose purpose is not obvious, present it to the user one at a time and let them decide. Include:

- What it is (one or two sentences)
- When it was installed: the modification time of `/opt/homebrew/Cellar/<name>` for formulae, `/opt/homebrew/Caskroom/<name>` for casks
- Dependents: `brew uses --installed <name>`
- Evidence of use: config files, data directories, related projects (for example, for rebar3, whether there are Gleam projects under `works/`)
- A recommendation to keep or remove, with the reason

How to look for evidence depends on the item. Absence of evidence does not prove the item is unused, so state what you checked.

When the user says something is unused, uninstall it right away. Do not ask again.

## 3. Clean up

- Remove formulae with `brew uninstall <name>` and casks with `brew uninstall --cask <name>`. `--zap` also deletes the app's data, so add it only when the user asks
- When Homebrew autoremoves dependencies, report the list. It can include commands that are also used on their own (for example, removing poppler also removes gnupg)
- Remove unused taps with `brew untap`

## 4. Reflect into the repository

### Writing the Brewfile

Group sections by purpose, not by formula versus cask.

- Everything used for development work goes into "開発", regardless of type: Git, language runtimes, build tools, cloud CLIs, containers, editors
- Tools built around AI agents go into "AI"
- Everything else goes into sections such as "シェルと基本コマンド", "ブラウザ", "コミュニケーションと共同作業", "認証とアクセス", "画像、動画、音声、文書" and "macOS の操作と入力". Follow the sections already in the Brewfile
- Within a section, list formulae first, then casks, each sorted by name
- When keeping something whose purpose is not clear from its name, add a trailing comment with the reason (for example, `brew "rebar3" # Gleam の Erlang ターゲットが ...`)

If you change how sections are grouped, confirm that the set of `tap`, `brew` and `cask` entries is identical before and after.

### Verify

- `brew bundle check --no-upgrade` is satisfied
- `brew leaves --installed-on-request` and `brew list --cask` match the Brewfile. If any item still differs, explain why in the report
- If mise tools changed, update the tool list in this repository's CLAUDE.md to match

### PR

Put structural changes (reordering sections) and behavioral changes (adding or removing entries) in separate commits, but keep them in one PR. Items to remove keep turning up during an inventory, and splitting into stacked PRs means rebasing every time. Follow the user's own rules for creating and reviewing the PR.

In the PR description, list:
- What was added
- What was removed and uninstalled
- What remains installed but is not in the Brewfile, and why
