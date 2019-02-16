#! /bin/sh

brew update

echo "=== Install Fish Shell"

brew install fish
sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

fish ./fish.sh

echo "=== Install Homebrew packages"

brew install tree
brew install curl
brew install wget
brew install peco
brew install git

brew tap caskroom/cask
brew tap homebrew/cask-versions
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox-developer-edition
brew cask install google-japanese-ime
brew cask install dropbox
brew cask install skitch
brew cask install jetbrains-toolbox
brew cask install visual-studio-code
brew cask install slack
brew cask install docker
