#! /bin/zsh -eux

echo "=== setup git"

ln -sf "$(pwd)/.gitconfig" ~/
ln -sf "$(pwd)/.gitignore_global" ~/

echo "=== Generate SSH key"

mkdir -p ~/.ssh
chmod 700 ~/.ssh
ln -sf "$(pwd)/ssh/config" ~/.ssh/config

ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_ed25519.pub | pbcopy
echo "Register your SSH key for GitHub"

open -a "Google Chrome" "https://github.com/settings/keys"
