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

echo "=== clean up legacy omf symlink"

[ -L ~/.config/omf ] && rm ~/.config/omf

echo "=== install Fisher + plugins"

# Fisher v4.4.8 (pinned by commit hash)
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/a04308be92daa6cfecdbb0ca58b1e8508664cff2/functions/fisher.fish | source && fisher update"

echo "=== generate shell completions"

eval "$(mise activate zsh)"
gh completion -s fish > ${fish_config_dir}/completions/gh.fish
