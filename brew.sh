#! /bin/sh

echo "=== Install Fish Shell"

brew install fish
sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

# fisherman (fish plugin manager)
echo "=== Install Fisherman"
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
fisher
fisher up

echo "=== Install Homebrew packages"

brew install tree
brew install curl
brew install wget
brew install git
brew install nodebrew
brew install rbenv
brew install nodenv

brew install caskroom/cask/brew-cask
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install sourcetree
brew cask install dropbox
brew cask install skitch
brew cask install jetbrains-toolbox
brew cask install visual-studio-code
brew cask install slack
