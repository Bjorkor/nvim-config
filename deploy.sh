#!/bin/bash

install_nvim(){
    echo "installing nvim..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux64.tar.gz
        sudo rm -rf nvim-linux64.tar.gz
        echo "adding nvim to path..."
        echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> "$HOME/.bashrc"
        source "$HOME/.bashrc"  # Reload the bash profile to apply changes immediately
    else
        echo "Unsupported operating system: $OSTYPE"
        exit 1
    fi
}

deploy_config(){
    folder_path="$HOME/.config/nvim"

    if [ ! -d "$folder_path" ]; then
        echo "nvim config dir does not exist. Creating..."
        mkdir -p "$folder_path"
        echo "nvim config dir created successfully."
    else
        echo "nvim config dir already exists."
    fi

    # Get the directory of the script
    script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # Set the destination path
    destination_path="$HOME/.config/nvim"

    # Copy files from script directory to destination
    cp -r "$script_dir"/* "$destination_path"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "config copied successfully."
    else
        echo "nothing was copied."
    fi
    }

if command -v nvim &> /dev/null; then
    deploy_config
else
    install_nvim
    deploy_config
fi

