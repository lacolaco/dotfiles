#! /bin/zsh -eux

echo "=== setup git"

ln -sf "$(pwd)/.gitconfig" ~/
ln -sf "$(pwd)/.gitignore_global" ~/

echo "=== Generate SSH key"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ln -sf "$(pwd)/ssh/config" ~/.ssh/config

ssh-keygen -t ed25519

echo "=== Authenticate GitHub CLI"

if ! gh auth status &>/dev/null; then
  gh auth login
fi

echo "=== Register SSH key to GitHub"

gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title "ed25519-auth-key-$(date +%Y%m%d)"
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing --title "ed25519-signing-key-$(date +%Y%m%d)"
