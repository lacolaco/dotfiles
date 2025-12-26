#! /bin/zsh -eux

echo "=== setup mise"

mise_config_dir="$(pwd)/mise"
ln -sf ${mise_config_dir} ~/.config/mise

echo "=== install mise tools"

mise install
mise doctor
