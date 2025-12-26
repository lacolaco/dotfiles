#! /bin/zsh -eux

echo "=== setup fish shell"

fish_config_dir="$(pwd)/fish"
ln -sf ${fish_config_dir} ~/.config/fish

fish -c "fish_add_path /opt/homebrew/bin"

echo "=== change default shell to fish"

fish_location=$(which fish)
sudo sh -c "echo ${fish_location} >> /etc/shells"
chsh -s ${fish_location}

echo "=== install Oh-my-fish"

omf_config_dir="$(pwd)/omf"
ln -sf ${omf_config_dir} ~/.config/omf
curl -L https://get.oh-my.fish | fish
