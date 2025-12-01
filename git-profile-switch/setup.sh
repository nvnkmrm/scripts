#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPS_SCRIPT="$SCRIPT_DIR/git-profile-switch"

# Make script executable
echo "Making git-profile-switch script executable..."
chmod +x "$GPS_SCRIPT"

# Create symlink
echo "Creating symlink in /usr/local/bin (requires sudo)..."
sudo mkdir -p /usr/local/bin
sudo ln -sf "$GPS_SCRIPT" /usr/local/bin/gps

echo "Adding command to your PATH..."

# Detect shell RC file
SHELL_NAME=$(basename "$SHELL")
case "$SHELL_NAME" in

    zsh) RC_FILE="$HOME/.zshrc" ;;
    bash) RC_FILE="${HOME}/.bashrc" ;;
    *) echo "Unsupported shell. Add 'gps work > /dev/null 2>&1' to your shell config manually."; exit 1 ;;
esac

# Ask user for default profile
echo "Choose default git profile for terminal:"
echo "1) work"
echo "2) personal"
echo "3) skip"
read -p "Enter choice (1, 2, or 3): " choice

case $choice in
    1) PROFILE="work" ;;
    2) PROFILE="personal" ;;
    3) echo "Skipping auto-switch."; exit 0 ;;
    *) echo "Invalid choice. Skipping auto-switch."; exit 0 ;;
esac

# Add auto-switch to RC file if not present
if ! grep -q "gps " "$RC_FILE" 2>/dev/null; then
    echo "" >> "$RC_FILE"
    echo "# Auto-switch to $PROFILE git profile" >> "$RC_FILE"
    echo "gps $PROFILE > /dev/null 2>&1" >> "$RC_FILE"
    echo "Added 'gps $PROFILE' to $RC_FILE"
fi

echo "Installation complete. Run: source $RC_FILE"
