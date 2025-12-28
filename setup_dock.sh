#! /bin/zsh -eux

echo "=== setup Dock"

# Remove all items from Dock
dockutil --remove all --no-restart

# Add essential apps (customize as needed)
# Finder is always present and cannot be removed

# Development
dockutil --add "/Applications/Visual Studio Code.app" --no-restart
dockutil --add "/Applications/Figma.app" --no-restart

# Browsers
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/Applications/Firefox.app" --no-restart

# Communication
dockutil --add "/Applications/Slack.app" --no-restart
dockutil --add "/Applications/Discord.app" --no-restart

# Utilities
dockutil --add "/System/Applications/System Settings.app" --no-restart
dockutil --add "/System/Applications/Utilities/Terminal.app" --no-restart

# Add more apps as needed:
# dockutil --add "/Applications/YourApp.app" --no-restart

# Restart Dock to apply changes
killall Dock

echo "Dock setup completed. Customize setup_dock.sh to add your preferred apps."
