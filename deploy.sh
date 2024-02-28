#!/bin/bash

# Get the directory of the script
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the destination path
destination_path="$HOME/.config/nvim"

# Copy files from script directory to destination
cp -r "$script_dir"/* "$destination_path"

# Check if the copy was successful
if [ $? -eq 0 ]; then
  echo "Files copied successfully."
else
  echo "Error copying files."
fi

