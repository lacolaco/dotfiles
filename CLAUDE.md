# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

個人のdotfilesリポジトリ。macOS開発環境のセットアップスクリプトと設定ファイルを管理する。

## Setup Commands

新規環境セットアップ時は順次実行:

```bash
# 1. Homebrew installation & Finder設定
./init.sh

# 2. パッケージインストール (Homebrewインストール後、PATHに追加してから)
brew bundle install
brew doctor

# 3. Git設定のシンボリックリンク作成 & SSH鍵生成
./setup_git.sh

# 4. mise設定のシンボリックリンク作成 & ツールインストール
./setup_mise.sh

# 5. Fish shell設定のシンボリックリンク作成 & デフォルトシェル変更
./setup_fish.sh

# 6. nodebrew setup (必要に応じて)
./setup_nodebrew.sh
```

## Architecture

### Symlink-based Configuration Management

このリポジトリの設定ファイルはホームディレクトリにシンボリックリンクを作成して使用される:

- `.gitconfig` → `~/.gitconfig`
- `.gitignore_global` → `~/.gitignore_global`
- `fish/` → `~/.config/fish`
- `mise/` → `~/.config/mise`
- `ssh/config` → `~/.ssh/config`

**重要**: 設定ファイルを編集する場合は、このリポジトリ内のファイルを直接編集すること。ホームディレクトリ内のファイルはシンボリックリンクなので、変更は自動的に反映される。

### Fish Shell Configuration Structure

- `fish/config.fish`: メイン設定ファイル
  - 環境変数 (LANG, VOLTA_HOME, PNPM_HOME等)
  - direnv/mise integration
  - カスタム関数 (`commit_empty`, `gitco`, `hp`, `p`)
- `fish/functions/fish_prompt.fish`: プロンプトカスタマイズ
- `fish/completions/`: 補完スクリプト
- `fish/conf.d/`: 追加設定ディレクトリ

### Package Manager Detection Logic

`p` function (fish/config.fish:24-34)は以下の優先順位でパッケージマネージャーを自動検出:

1. bun.lockb → bun
2. pnpm-lock.yaml → pnpm
3. yarn.lock → yarn
4. デフォルト → npm

## Tool Management Strategy

### Homebrew vs mise

- **Homebrew**: システムレベルツール、GUIアプリ (cask)、mise自体
- **mise**: プログラミング言語、CLI開発ツール (gh, glab, deno等)

**mise管理ツール (mise/config.toml)**:
- Languages: node 22, python, go
- CLI tools: gh, glab, deno, watchexec, ollama
- npm globals: claude-code, gemini-cli, mdtranslator, codex
- pipx: openhands-ai

Brewfileとmiseで重複管理しないこと。新規ツール追加時は適切な方を選択。

## Important Notes

- Git commits are signed with SSH keys (gpg.format = ssh)
- Default branch is `main` (init.defaultBranch)
- VSCode is configured as default Git editor
- このリポジトリ自体のmasterブランチがメインブランチ
