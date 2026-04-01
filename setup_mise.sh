#! /bin/zsh -eux

echo "=== setup mise"

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
mise_config_dir="$(pwd)/mise"
link_dir "${mise_config_dir}" ~/.config/mise

echo "=== install mise tools"

eval "$(mise activate zsh)"
mise install
mise doctor
