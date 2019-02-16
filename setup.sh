#! /bin/sh

cp -R .gitconfig ~/
mkdir -p ~/.config/fish && cp -R ./fish ~/.config/

# for Sierra
touch ~/.ssh/config
SSH_CONFIG=`cat ./ssh/config`
echo "$SSH_CONFIG" > ~/.ssh/config

echo "=== Generate SSH key"

ssh-keygen
cat ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub | pbcopy
echo "Register your SSH key for GitHub"
open "https://github.com/settings/keys"
read -p "Press any key after finished."

# Homebrew
echo "=== Install Homebrew"

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

./brew.sh

brew doctor

# nodebrew
echo "=== Install Nodebrew"
curl -L git.io/nodebrew | perl - setup
nodebrew install-binary v10
nodebrew use latest v10
npm set progress=false # raise performance

echo "=== Setup Mac environment"
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

# Git
git config --global core.editor 'nano'
