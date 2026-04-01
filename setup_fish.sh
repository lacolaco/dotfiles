#! /bin/zsh -eux

echo "=== setup fish shell"

backup_suffix=".backup.$(date +%Y%m%d_%H%M%S)"

link_dir() {
    local src=$1
    local dest=$2

    if [ -L "$dest" ]; then
        echo "Removing existing symlink: $dest"
        rm "$dest"
    elif [ -d "$dest" ]; then
        echo "Backing up existing directory: $dest → ${dest}${backup_suffix}"
        mv "$dest" "${dest}${backup_suffix}"
    fi

    ln -sf "$src" "$dest"
    echo "  $dest → $src"
}

mkdir -p ~/.config
fish_config_dir="$(pwd)/fish"
link_dir "${fish_config_dir}" ~/.config/fish

fish -c "fish_add_path /opt/homebrew/bin"

echo "=== change default shell to fish"

fish_location=$(which fish)
sudo sh -c "echo ${fish_location} >> /etc/shells"
chsh -s ${fish_location}

echo "=== install Oh-my-fish"

omf_config_dir="$(pwd)/omf"
link_dir "${omf_config_dir}" ~/.config/omf
curl -L https://get.oh-my.fish | fish

echo "=== generate shell completions"

eval "$(mise activate zsh)"
gh completion -s fish > ${fish_config_dir}/completions/gh.fish
