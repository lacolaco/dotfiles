# CLAUDE.md

macOS開発環境セットアップ用dotfilesリポジトリ。Symlink方式で設定を管理。

## Critical Rules

### Symlink編集の絶対ルール
このリポジトリ内のファイルを直接編集すること。`~/.gitconfig`などホームディレクトリ内のファイルはsymlinkのため、編集してはならない。

### 重複管理の禁止
Homebrewとmiseで同じツールを管理しない：
- **Homebrew**: システムツール、GUIアプリ、mise本体
- **mise**: プログラミング言語、CLI開発ツール

### Brewfile管理ポリシー
- `brew`と`cask`のみ記述
- VSCode拡張、go/cargoパッケージは含めない
- `brew bundle dump`は使わない（依存関係まで含むため）
- `brew leaves --installed-on-request`を基準に手動管理

## Repository Structure

### Symlink Mappings
```
.gitconfig → ~/.gitconfig
.gitignore_global → ~/.gitignore_global
fish/ → ~/.config/fish
karabiner/ → ~/.config/karabiner
mise/ → ~/.config/mise
omf/ → ~/.config/omf
ssh/config → ~/.ssh/config
```

### Setup Scripts
1. `init.sh`: Homebrew + Rosetta 2インストール、Finder設定
2. `setup_mise.sh`: mise設定 + ツールインストール
3. `setup_git.sh`: Git設定 + SSH鍵生成/GitHub登録（`gh`必要）
4. `setup_fish.sh`: Fish設定 + デフォルトシェル変更 + Oh-my-fish
5. `setup_dock.sh`: Dock完全クリア + 必要アプリ配置（カスタマイズ可能）

### Tool Management
**Homebrew** (Brewfile):
- システムツール: git, fish, docker, direnv, jq等
- GUIアプリ: VSCode, Chrome, Slack等
- aqua, mise本体

**mise** (mise/config.toml):
- 言語: node, python, go, deno
- CLIツール: gh, glab, watchexec
- npm globals: claude-code, gemini-cli等
- aqua経由: pinact
- go経由: deck
- ubi経由: glab

## Operations

### 新規環境セットアップ

```bash
# 1. Homebrew + Rosetta 2インストール
./init.sh

# 2. PATHにHomebrewを追加後、パッケージインストール
brew bundle install
brew doctor

# 3. Karabiner-Elements設定（symlinkを先に作成してから起動）
ln -sf $(pwd)/karabiner ~/.config/karabiner

# 4. mise設定（ghコマンドが必要なため先に実行）
./setup_mise.sh

# 5. Git設定 + SSH鍵生成/GitHub登録
./setup_git.sh

# 6. Fish設定
./setup_fish.sh

# 7. Dock設定（オプション: スクリプト編集で好みのアプリを指定）
./setup_dock.sh
```

### Brewfile更新

```bash
# 1. 現在の状態を確認（mise管理ツールに注釈付き）
./update_brewfile.sh

# 2. 不要なパッケージ・tapを削除
brew uninstall <package>
brew untap <tap>

# 3. Brewfileを手動更新
# - update_brewfile.shの出力を基に記述
# - mise管理ツール（gh, node, python等）は除外
# - VSCode/go/cargoエントリは除外
```

### Troubleshooting

**Symlink conflict**:
```bash
# 既存ファイルが存在する場合、バックアップして削除
mv ~/.gitconfig ~/.gitconfig.backup
ln -sf $(pwd)/.gitconfig ~/
```

**mise install失敗**:
```bash
# mise自体を再インストール
brew reinstall mise

# 個別ツール再インストール
mise install <tool>@<version>
```

**GitHub CLI認証エラー**:
```bash
# 認証を再実行（admin:public_key, admin:ssh_signing_key scopesが必要）
gh auth refresh -h github.com -s admin:public_key -s admin:ssh_signing_key
```

## Technical Reference

### Git Configuration
- コミット署名: SSH鍵使用 (`gpg.format = ssh`)
- デフォルトブランチ: `main`
- エディタ: VSCode

### Fish Shell
- **設定ファイル**: `fish/config.fish`
  - 環境変数 (LANG, PNPM_HOME等)
  - direnv/mise integration
  - カスタム関数: `commit_empty`, `gitco`, `hp`, `p`
- **プロンプト**: `fish/functions/fish_prompt.fish`
- **Oh-my-fish**: テーマ・プラグイン管理

### Package Manager Auto-detection
`p` function: lockfileを検出して自動選択
1. `bun.lockb` → bun
2. `pnpm-lock.yaml` → pnpm
3. `yarn.lock` → yarn
4. デフォルト → npm

### Platform Constraints
- **Rosetta 2**: Intel版アプリ用（google-japanese-ime等）
  - macOS 28（2027年）でサポート終了予定
- **google-japanese-ime**: Apple Siliconネイティブ非対応

### Excluded from Version Control
- `Brewfile.lock.json`: 個人用dotfilesのため不使用
