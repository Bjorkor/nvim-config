#!/bin/bash

# --- Configuration ---
VERSION="v0.9.5"
ASSET_NAME="nvim-linux64.tar.gz"
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/$VERSION/$ASSET_NAME"
EXTRACT_DIR_NAME="nvim-linux64"
INSTALL_PATH="/opt/$EXTRACT_DIR_NAME"
BIN_PATH="$INSTALL_PATH/bin"
# --- End Configuration ---

# This function installs/updates to a specific Neovim version
install_nvim(){
    echo "Installing Neovim $VERSION..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux

        echo "Downloading from: $DOWNLOAD_URL"
        curl -LO "$DOWNLOAD_URL"
        
        # Check if download was successful (file exists and is not empty)
        if [ ! -s "$ASSET_NAME" ]; then
            echo "Error: Download failed or file is empty."
            sudo rm -f "$ASSET_NAME"
            exit 1
        fi

        # Remove old version if it exists
        echo "Removing old nvim installation from $INSTALL_PATH..."
        sudo rm -rf "$INSTALL_PATH"
        
        echo "Extracting new version to /opt/..."
        sudo tar -C /opt -xzf "$ASSET_NAME"
        sudo rm -f "$ASSET_NAME" # Use -f to force remove

        # Add to path for *this script's session*
        export PATH="$PATH:$BIN_PATH"

        # Add to path for *future* shell sessions, if not already present
        if ! grep -q "PATH=\"\$PATH:$BIN_PATH\"" "$HOME/.bashrc"; then
            echo "Adding nvim to .bashrc path..."
            echo '' >> "$HOME/.bashrc"
            echo '# Add Neovim to path' >> "$HOME/.bashrc"
            echo "export PATH=\"\$PATH:$BIN_PATH\"" >> "$HOME/.bashrc"
        else
            echo "Nvim path already present in .bashrc."
        fi
    else
        echo "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    echo "Neovim installation complete."
}

# This function deploys your config files
deploy_config(){
    echo "Deploying nvim config..."
    local folder_path="$HOME/.config/nvim"

    if [ ! -d "$folder_path" ]; then
        echo "nvim config dir does not exist. Creating..."
        mkdir -p "$folder_path"
    else
        echo "nvim config dir already exists."
    fi

    # Get the directory of the script
    local script_dir
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Set the destination path
    local destination_path="$HOME/.config/nvim"

    # Copy files from script directory to destination
    echo "Syncing config files from $script_dir to $destination_path..."
    rsync -a --delete "$script_dir"/ "$destination_path"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Config deployed successfully."
    else
        echo "Config deployment failed."
    fi
}

### MAIN EXECUTION ###

# 1. Install/Update Neovim to the specific version
install_nvim

# 2. Deploy the config
deploy_config

echo ""
echo "Done. You may need to restart your terminal for path changes to apply."
