#! /bin/sh

cp -R .gitconfig ~/
cp -R ./fish ~/.config

# Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

./brew.sh

# node
nodebrew install-binary 6
nodebrew use 6

# 非公開ファイルの表示
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

ssh-keygen
cat ~/.ssh/id_rsa.pub | pbcopy
# ssh公開鍵をいろいろなところに配る
