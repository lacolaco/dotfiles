#! /bin/sh

cp -p .gitconfig ~/
cp -p fish ~/.config

# Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

./brew.sh

# 非公開ファイルの表示
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

ssh-keygen
cat ~/.ssh/id_rsa.pub | pbcopy
# ssh公開鍵をいろいろなところに配る

# node
curl -L git.io/nodebrew | perl - setup
nodebrew install-binary 6
nodebrew use 6

# AppEngine
echo "Download AppEngine SDK"
open https://cloud.google.com/appengine/downloads
