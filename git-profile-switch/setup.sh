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

# Read profiles from profiles.yaml
PROFILES_YAML="$SCRIPT_DIR/profiles.yaml"
if [[ ! -f "$PROFILES_YAML" ]]; then
    echo "profiles.yaml not found at $PROFILES_YAML"
    exit 1
fi

# Extract profile names from profiles.yaml
PROFILES=()
while IFS= read -r line; do
    PROFILES+=("$line")
done <<< "$(grep -E '^\s*-\s*name:' "$PROFILES_YAML" | awk -F': ' '{print $2}')"

# Ask user for default profile
echo "Choose default git profile for terminal:"
for i in "${!PROFILES[@]}"; do
    echo "$((i+1))) ${PROFILES[$i]}"
done
SKIP_NUM=$((${#PROFILES[@]} + 1))
echo "$SKIP_NUM) skip"
read -p "Enter choice (1-$SKIP_NUM): " choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 && "$choice" -lt "$SKIP_NUM" ]]; then
    PROFILE="${PROFILES[$((choice-1))]}"
elif [[ "$choice" == "$SKIP_NUM" ]]; then
    echo "Skipping auto-switch."
    exit 0
else
    echo "Invalid choice. Skipping auto-switch."
    exit 0
fi

# Remove existing gps entry (comment + command) if present, then add updated one
if grep -q "gps " "$RC_FILE" 2>/dev/null; then
    sed -i '' '/# Auto-switch to .* git profile/d' "$RC_FILE"
    sed -i '' '/gps .* > \/dev\/null 2>&1/d' "$RC_FILE"
    sed -i '' '/^[[:space:]]*$/d' "$RC_FILE"
    echo "Removed existing gps entry from $RC_FILE"
fi
echo "# Auto-switch to $PROFILE git profile" >> "$RC_FILE"
echo "gps $PROFILE > /dev/null 2>&1" >> "$RC_FILE"
echo "Added 'gps $PROFILE' to $RC_FILE"

echo "Installation complete. Run: source $RC_FILE"
