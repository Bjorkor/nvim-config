#!/bin/bash

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

# 1. Check if nvim is installed
if ! command -v nvim &> /dev/null; then
    echo "Neovim command 'nvim' not found."
    echo "Please install it first (e.g., sudo apt install neovim) and re-run."
    exit 1
fi

# 2. Deploy the config
deploy_config

echo ""
echo "Done."
