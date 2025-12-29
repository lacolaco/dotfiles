#! /bin/zsh -eux

echo "=== setup Claude Code configuration"

claude_dir="$(pwd)/claude"
backup_suffix=".backup.$(date +%Y%m%d_%H%M%S)"

# ~/.claudeディレクトリを作成（存在しない場合）
mkdir -p ~/.claude

# 個別ファイルのsymlink作成関数
link_file() {
    local src=$1
    local dest=$2

    if [ -L "$dest" ]; then
        echo "Removing existing symlink: $dest"
        rm "$dest"
    elif [ -f "$dest" ]; then
        echo "Backing up existing file: $dest → ${dest}${backup_suffix}"
        mv "$dest" "${dest}${backup_suffix}"
    fi

    ln -sf "$src" "$dest"
    echo "  $dest → $src"
}

# 個別ディレクトリのsymlink作成関数
link_dir() {
    local src=$1
    local dest=$2

    if [ -L "$dest" ]; then
        echo "Removing existing symlink: $dest"
        rm "$dest"
    elif [ -d "$dest" ]; then
        echo "Backing up existing directory: $dest → ${dest}${backup_suffix}"
        mv "$dest" "${dest}${backup_suffix}"
    fi

    ln -sf "$src" "$dest"
    echo "  $dest → $src"
}

# ファイルをsymlink
link_file "${claude_dir}/CLAUDE.md" ~/.claude/CLAUDE.md
link_file "${claude_dir}/settings.json" ~/.claude/settings.json

# サブディレクトリをsymlink
link_dir "${claude_dir}/agents" ~/.claude/agents
link_dir "${claude_dir}/commands" ~/.claude/commands

echo "=== Claude Code configuration symlinked"
