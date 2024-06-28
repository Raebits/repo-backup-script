#!/bin/bash

# Default organization name
DEFAULT_ORG_NAME="semarangplaza"

# Read organization name from environment variable or parameter
ORG_NAME="${1:-${ORG_NAME:-$DEFAULT_ORG_NAME}}"

# Base directory to store repositories (replace with the desired local directory)
BASE_DIR="$HOME/.github-backups/$ORG_NAME"

# Ensure the base directory exists
mkdir -p "$BASE_DIR"

# Change to the base directory
cd "$BASE_DIR"

# List all repositories in the organization
REPOS=$(gh repo list "$ORG_NAME" --json name -q '.[].name')

# Iterate over each repository
for REPO in $REPOS; do
    if [ -d "$REPO" ]; then
        # If the repository directory already exists, pull the latest changes
        echo "Updating $REPO..."
        cd "$REPO"
        git pull
        cd ..
    else
        # If the repository directory does not exist, clone the repository
        echo "Cloning $REPO..."
        gh repo clone "$ORG_NAME/$REPO"
    fi
done

echo "All repositories have been backed up and synced."
