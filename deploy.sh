#!/bin/bash

# This function installs/updates to the latest 'stable' release of Neovim
# It will also add the nvim path to .bashrc if it's not already there
install_nvim(){
    echo "Installing latest stable Neovim..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        
        # Remove old version if it exists
        echo "Removing old nvim installation from /opt/nvim-linux64..."
        sudo rm -rf /opt/nvim-linux64 
        
        echo "Extracting new version to /opt/..."
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo rm -rf nvim-linux64.tar.gz

        # Add to path for *this script's session*
        # This ensures the 'deploy_config' step can find nvim if it needs it
        export PATH="$PATH:/opt/nvim-linux64/bin"

        # Add to path for *future* shell sessions, if not already present
        if ! grep -q 'PATH="$PATH:/opt/nvim-linux64/bin"' "$HOME/.bashrc"; then
            echo "Adding nvim to .bashrc path..."
            echo '' >> "$HOME/.bashrc"
            echo '# Add Neovim to path' >> "$HOME/.bashrc"
            echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> "$HOME/.bashrc"
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

# 1. Always install/update to the latest stable Neovim
install_nvim

# 2. Always deploy the config
deploy_config

echo ""
echo "Done. You may need to restart your terminal for path changes to apply."
