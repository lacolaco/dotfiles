#! /bin/zsh -eu

echo "=== Brewfile Update Helper ==="
echo ""

# Define mise-managed tools (from mise/config.toml)
MISE_TOOLS=(gh node python go deno watchexec glab)

echo "📦 Current Taps:"
brew tap

echo ""
echo "🍺 Current Brews (installed on request):"
brew leaves --installed-on-request | while read formula; do
  # Check if mise-managed
  if [[ " ${MISE_TOOLS[@]} " =~ " ${formula} " ]]; then
    echo "  $formula (⚠️  SKIP: mise-managed)"
  else
    echo "  $formula"
  fi
done

echo ""
echo "📦 Current Casks:"
brew list --cask | while read cask; do
  echo "  $cask"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Next steps:"
echo "1. Review the output above"
echo "2. Manually update Brewfile based on the list"
echo "3. Remove entries marked as '⚠️  SKIP: mise-managed'"
echo "4. Exclude VSCode/go/cargo packages (not shown here)"
echo ""
echo "Current Brewfile location: $(pwd)/Brewfile"
