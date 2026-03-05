#!/bin/bash

# --- Configuration ---
VERSION="v0.10.4"
ASSET_NAME="nvim-linux-x86_64.appimage"
DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/$VERSION/$ASSET_NAME"
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
            rm -f "$ASSET_NAME"
            exit 1
        fi

        echo "Preparing AppImage..."
        chmod u+x "$ASSET_NAME"
        
        # Extract the AppImage to bypass potential FUSE requirements on headless servers
        ./"$ASSET_NAME" --appimage-extract > /dev/null
        
        echo "Cleaning up old installations in /opt..."
        sudo rm -rf /opt/nvim-linux64 /opt/nvim-linux-x86_64 /opt/nvim-appimage
        
        echo "Moving extracted Neovim to /opt/..."
        sudo mv squashfs-root /opt/nvim-appimage
        rm -f "$ASSET_NAME"

        # The executable inside the extracted AppImage is located here:
        BIN_PATH="/opt/nvim-appimage/usr/bin"

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
