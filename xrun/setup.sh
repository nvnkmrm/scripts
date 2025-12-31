#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XRUN_SCRIPT="$SCRIPT_DIR/xrun"

# Make script executable
echo "Making xrun script executable..."
chmod +x "$XRUN_SCRIPT"

# Create symlink
echo "Creating symlink in /usr/local/bin (requires sudo)..."
sudo mkdir -p /usr/local/bin
sudo ln -sf "$XRUN_SCRIPT" /usr/local/bin/xrun

echo ""
echo "✓ Installation complete!"
echo ""
echo "You can now use the command:"
echo "  xrun [OPTIONS] <command>"
echo ""
echo "Examples:"
echo "  xrun \"git status\""
echo "  xrun --depth 2 \"npm test\""
echo "  xrun -d 3 -p ~/projects \"ls -la\""
echo ""
echo "For more options, run:"
echo "  xrun --help"
