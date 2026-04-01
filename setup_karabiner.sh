#! /bin/zsh -eux

echo "=== setup Karabiner-Elements configuration"

karabiner_src="$(pwd)/karabiner"
karabiner_dest=~/.config/karabiner
backup_suffix=".backup.$(date +%Y%m%d_%H%M%S)"

mkdir -p ~/.config

if [ -L "$karabiner_dest" ]; then
    echo "Removing existing symlink: $karabiner_dest"
    rm "$karabiner_dest"
elif [ -d "$karabiner_dest" ]; then
    echo "Backing up existing directory: $karabiner_dest → ${karabiner_dest}${backup_suffix}"
    mv "$karabiner_dest" "${karabiner_dest}${backup_suffix}"
fi

ln -sf "$karabiner_src" "$karabiner_dest"
echo "  $karabiner_dest → $karabiner_src"

echo "=== Karabiner-Elements configuration symlinked"
