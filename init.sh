#! /bin/zsh -eux

echo "=== Setup Mac environment"

defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

echo "=== Install Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "=== Install Rosetta 2 (required for Intel-based apps)"

sudo softwareupdate --install-rosetta --agree-to-license

echo "Execute following commands after add brew to PATH."
echo "brew bundle install"
echo "brew doctor"
echo "./setup_git.sh"
echo "./setup_mise.sh"
echo "./setup_fish.sh"
