#!/bin/bash

# Git Profile Switch - Installation Script
# This script installs the gps command and configures your shell

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GPS_SCRIPT="$SCRIPT_DIR/git-profile-switch"

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check if git-profile-switch exists
if [ ! -f "$GPS_SCRIPT" ]; then
    print_error "git-profile-switch script not found at $GPS_SCRIPT"
    exit 1
fi

print_info "Starting Git Profile Switch installation..."

# Step 1: Make the script executable
print_info "Making git-profile-switch executable..."
chmod +x "$GPS_SCRIPT"
print_success "Script is now executable"

# Step 2: Create symlink in /usr/local/bin
print_info "Creating symlink in /usr/local/bin..."

# Check if /usr/local/bin exists, create if not
if [ ! -d "/usr/local/bin" ]; then
    print_info "/usr/local/bin doesn't exist, creating it..."
    sudo mkdir -p /usr/local/bin
fi

# Create or update the symlink
if sudo ln -sf "$GPS_SCRIPT" /usr/local/bin/gps; then
    print_success "Symlink created at /usr/local/bin/gps"
else
    print_error "Failed to create symlink. You may need to run with sudo."
    exit 1
fi

# Verify the command is accessible
if command -v gps > /dev/null 2>&1; then
    print_success "gps command is now available in your PATH"
else
    print_error "gps command not found in PATH. You may need to add /usr/local/bin to your PATH"
fi

# Step 3: Configure shell RC file
print_info "Configuring shell initialization..."

# Detect the current shell and appropriate RC file
SHELL_NAME=$(basename "$SHELL")
RC_FILE=""

case "$SHELL_NAME" in
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    bash)
        # Check for .bashrc first, then .bash_profile
        if [ -f "$HOME/.bashrc" ]; then
            RC_FILE="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            RC_FILE="$HOME/.bash_profile"
        else
            RC_FILE="$HOME/.bashrc"
        fi
        ;;
    *)
        print_error "Unsupported shell: $SHELL_NAME"
        print_info "Please manually add 'gps work > /dev/null 2>&1' to your shell configuration"
        exit 0
        ;;
esac

print_info "Detected shell: $SHELL_NAME"
print_info "Configuration file: $RC_FILE"

# Check if the RC file exists, create if not
if [ ! -f "$RC_FILE" ]; then
    print_info "$RC_FILE doesn't exist, creating it..."
    touch "$RC_FILE"
fi

# Check if the gps initialization is already present
GPS_INIT_LINE="gps work > /dev/null 2>&1"

if grep -q "gps work" "$RC_FILE" 2>/dev/null; then
    print_info "gps initialization already exists in $RC_FILE"
    
    # Ask if user wants to update it
    read -p "Do you want to ensure it's set to the correct format? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove old entries and add the new one
        grep -v "gps work" "$RC_FILE" > "$RC_FILE.tmp" || true
        echo "" >> "$RC_FILE.tmp"
        echo "# Auto-switch to work git profile on shell startup" >> "$RC_FILE.tmp"
        echo "$GPS_INIT_LINE" >> "$RC_FILE.tmp"
        mv "$RC_FILE.tmp" "$RC_FILE"
        print_success "Updated gps initialization in $RC_FILE"
    fi
else
    # Add the initialization line
    echo "" >> "$RC_FILE"
    echo "# Auto-switch to work git profile on shell startup" >> "$RC_FILE"
    echo "$GPS_INIT_LINE" >> "$RC_FILE"
    print_success "Added gps initialization to $RC_FILE"
fi

# Final summary
echo ""
echo "=========================================="
print_success "Installation completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Close and reopen your terminal, or run: source $RC_FILE"
echo "  2. Test the command: gps work"
echo "  3. Available profiles: personal | work"
echo ""
echo "The 'gps work' command will run automatically when you open a new terminal."
echo ""
