#! /bin/zsh -eux

echo "=== setup git"

eval "$(mise activate zsh)"

backup_suffix=".backup.$(date +%Y%m%d_%H%M%S)"

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

link_file "$(pwd)/.gitconfig" ~/.gitconfig
link_file "$(pwd)/.gitignore_global" ~/.gitignore_global

echo "=== Generate SSH key"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
link_file "$(pwd)/ssh/config" ~/.ssh/config

ssh-keygen -t ed25519

echo "=== Authenticate GitHub CLI"

if ! gh auth status &>/dev/null; then
  gh auth login
fi

gh auth refresh -h github.com -s admin:public_key -s admin:ssh_signing_key

echo "=== Register SSH key to GitHub"

gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "ed25519-auth-key-$(date +%Y%m%d)"
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "ed25519-signing-key-$(date +%Y%m%d)"
