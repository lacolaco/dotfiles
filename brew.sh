#! /bin/sh

brew install fish
sudo sh -c "echo '/usr/local/bin/fish' >> /etc/shells"
chsh -s /usr/local/bin/fish

# fisherman (fish plugin manager)
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
fisher

brew install tree
brew install curl
brew install wget
brew install git

brew install caskroom/cask/brew-cask
brew cask install google-japanese-ime
brew cask install sourcetree
brew cask install dropbox
brew cask install skitch
brew cask install charles
brew cask install gitter
brew cask install webstorm
brew cask install visual-studio-code
