#! /bin/zsh -eux

echo "=== setup SwiftBar"

# プラグインディレクトリを symlink し、SwiftBar に参照させる
swiftbar_src="$(pwd)/swiftbar"
swiftbar_dest=~/.config/swiftbar

mkdir -p ~/.config
if [ -L "$swiftbar_dest" ]; then
    rm "$swiftbar_dest"
elif [ -d "$swiftbar_dest" ]; then
    mv "$swiftbar_dest" "${swiftbar_dest}.backup.$(date +%Y%m%d_%H%M%S)"
fi
ln -sf "$swiftbar_src" "$swiftbar_dest"

defaults write com.ameba.SwiftBar PluginDirectory "$swiftbar_dest"

echo "SwiftBar setup completed. Restart SwiftBar.app to load plugins."
