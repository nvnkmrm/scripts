#!/bin/bash

# Script to clone git repositories based on team YAML configuration
# Usage: ./cloner.sh <team>
# Example: ./cloner.sh a

set -e

# Check if team argument is provided
if [ -z "$1" ]; then
    echo "Error: Team argument is required"
    echo "Usage: $0 <team>"
    echo "Example: $0 a"
    exit 1
fi

TEAM="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YAML_FILE="${SCRIPT_DIR}/team-${TEAM}.yaml"

# Check if the YAML file exists
if [ ! -f "$YAML_FILE" ]; then
    echo "Error: YAML file not found: $YAML_FILE"
    echo "Available team files:"
    ls -1 "${SCRIPT_DIR}"/team-*.yaml 2>/dev/null | sed 's/.*team-\(.*\)\.yaml/  - \1/' || echo "  (none found)"
    exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "⚠️  yq is not installed"
    echo ""
    read -p "Would you like to install yq using Homebrew? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Check if brew is installed
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew is not installed"
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
        
        echo "Installing yq..."
        if brew install yq; then
            echo "✅ yq installed successfully"
        else
            echo "❌ Failed to install yq"
            exit 1
        fi
    else
        echo "Installation cancelled. Please install yq manually:"
        echo "  brew install yq"
        exit 1
    fi
fi

echo "Using configuration file: $YAML_FILE"
echo "----------------------------------------"

# Get number of projects
PROJECT_COUNT=$(yq eval '.projects | length' "$YAML_FILE")

if [ "$PROJECT_COUNT" -eq 0 ]; then
    echo "No projects found in $YAML_FILE"
    exit 0
fi

# Clone each project
for ((i=0; i<$PROJECT_COUNT; i++)); do
    echo ""
    
    # Get URL and folder for the project
    URL=$(yq eval ".projects[$i].url" "$YAML_FILE")
    FOLDER=$(yq eval ".projects[$i].folder" "$YAML_FILE")
    
    # Check if URL is valid
    if [ "$URL" = "null" ] || [ -z "$URL" ]; then
        echo "  ⚠️  Skipping project at index $i: No URL specified"
        continue
    fi
    
    # If folder is not specified or is null, extract repo name from URL
    if [ "$FOLDER" = "null" ] || [ -z "$FOLDER" ]; then
        FOLDER=$(basename "$URL" .git)
    fi
    
    echo "Processing project:"
    echo "  URL: $URL"
    echo "  Folder: $FOLDER"
    
    # If folder is specified, create it and clone inside
    if [ "$FOLDER" != "null" ] && [ -n "$FOLDER" ]; then
        # Extract repo name from URL
        REPO_NAME=$(basename "$URL" .git)
        TARGET_PATH="$FOLDER/$REPO_NAME"
        FULL_PATH="$(cd "$(dirname "$TARGET_PATH")" 2>/dev/null && pwd || echo "$PWD")/$REPO_NAME"
        
        echo "  Target: $FULL_PATH"
        
        # Check if directory already exists
        if [ -d "$TARGET_PATH" ]; then
            echo "  ⚠️  Skipping: Directory already exists"
            continue
        fi
        
        # Create parent folder
        mkdir -p "$FOLDER"
        
        # Clone the repository into the folder
        echo "  🔄 Cloning..."
        if git clone "$URL" "$TARGET_PATH"; then
            FULL_PATH="$(cd "$TARGET_PATH" && pwd)"
            echo "  ✅ Successfully cloned to: $FULL_PATH"
        else
            echo "  ❌ Failed to clone"
        fi
    else
        # No folder specified, clone to current directory with repo name
        REPO_NAME=$(basename "$URL" .git)
        FULL_PATH="$PWD/$REPO_NAME"
        
        echo "  Target: $FULL_PATH"
        
        # Check if directory already exists
        if [ -d "$REPO_NAME" ]; then
            echo "  ⚠️  Skipping: Directory already exists"
            continue
        fi
        
        # Clone the repository
        echo "  🔄 Cloning..."
        if git clone "$URL"; then
            FULL_PATH="$(cd "$REPO_NAME" && pwd)"
            echo "  ✅ Successfully cloned to: $FULL_PATH"
        else
            echo "  ❌ Failed to clone"
        fi
    fi
done

echo ""
echo "----------------------------------------"
echo "Done!"
