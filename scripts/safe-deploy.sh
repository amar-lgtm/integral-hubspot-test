#!/bin/bash

# Safe deployment script for HubSpot themes
# This script helps prevent accidental overwrites

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

THEME_PATH="themes/integral-custom-quote"
REMOTE_PATH="themes/integral-custom-quote"

echo -e "${GREEN}=== HubSpot Safe Deployment Script ===${NC}\n"

# Check if HubSpot CLI is installed
if ! command -v hs &> /dev/null; then
    echo -e "${RED}Error: HubSpot CLI not found. Please install it first:${NC}"
    echo "npm install -g @hubspot/cli"
    exit 1
fi

# Check if theme directory exists
if [ ! -d "$THEME_PATH" ]; then
    echo -e "${RED}Error: Theme directory not found: $THEME_PATH${NC}"
    exit 1
fi

# Show what will be uploaded
echo -e "${YELLOW}Files that will be uploaded:${NC}"
find "$THEME_PATH" -type f | while read file; do
    echo "  - $file"
done
echo ""

# Ask for confirmation
read -p "Do you want to proceed with the upload? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo -e "${YELLOW}Upload cancelled.${NC}"
    exit 0
fi

# Check if files exist remotely (optional - requires list command)
echo -e "${YELLOW}Checking remote files...${NC}"
if hs cms list "$REMOTE_PATH" &> /dev/null; then
    echo -e "${YELLOW}Warning: Files already exist at $REMOTE_PATH${NC}"
    echo "This will overwrite existing files."
    read -p "Continue anyway? (yes/no): " overwrite_confirm
    if [ "$overwrite_confirm" != "yes" ]; then
        echo -e "${YELLOW}Upload cancelled.${NC}"
        exit 0
    fi
fi

# Perform the upload
echo -e "${GREEN}Uploading theme to HubSpot...${NC}"
if hs upload "$THEME_PATH" "$REMOTE_PATH"; then
    echo -e "${GREEN}✓ Upload completed successfully!${NC}"
else
    echo -e "${RED}✗ Upload failed!${NC}"
    exit 1
fi

echo -e "\n${GREEN}Deployment complete!${NC}"
echo "You can now view your theme in HubSpot Design Manager."

