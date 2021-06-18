#! /bin/zsh -eux

echo "=== setup git"

ln -sf "$(pwd)/.gitconfig" ~/
ln -sf "$(pwd)/.gitignore_global" ~/

echo "=== Generate SSH key"

ln -sf "$(pwd)/ssh/config" ~/.ssh/config

ssh-keygen
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub | pbcopy
echo "Register your SSH key for GitHub"

open -a "Google Chrome" "https://github.com/settings/keys"
