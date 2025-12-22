#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPRA_SCRIPT="$SCRIPT_DIR/git-pull-rebase-all"

# Make script executable
echo "Making git-pull-rebase-all script executable..."
chmod +x "$GPRA_SCRIPT"

# Create symlink
echo "Creating symlink in /usr/local/bin (requires sudo)..."
sudo mkdir -p /usr/local/bin
sudo ln -sf "$GPRA_SCRIPT" /usr/local/bin/git-pull-rebase-all
sudo ln -sf "$GPRA_SCRIPT" /usr/local/bin/gpra

echo ""
echo "✓ Installation complete!"
echo ""
echo "You can now use either command:"
echo "  - git-pull-rebase-all [directory]"
echo "  - gpra [directory]"
echo ""
echo "Example:"
echo "  cd ~/projects && gpra"
echo "  gpra ~/workspace"
