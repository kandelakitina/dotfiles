#!/bin/bash

# Simple APT INSTALL aps
# ======================

# List of applications to install
apps=(
    goldendict
    unzip
    qt5ct # qt5 theme patcher (for goldendict)
    # Add more applications here
)

# Iterate over the list of applications
for app in "${apps[@]}"; do
    # Check if the application is already installed
    if ! command -v "$app" &> /dev/null; then
        echo "$app is not installed. Installing..."
        sudo apt-get update
        sudo apt-get install -y "$app"
    else
        echo "$app is already installed."
    fi
done

# Manually installed apps
# =======================

# Anki
# ####

# Check if Anki is installed
if ! command -v anki &> /dev/null; then
    echo "Anki is not installed. Installing..."
    
    # Set the download directory
    download_dir="$HOME/Downloads"
    
    # Navigate to the download directory
    cd "$download_dir"
    
    # Download Anki
    wget https://github.com/ankitects/anki/releases/download/2.1.64/anki-2.1.64-linux-qt6.tar.zst
    
    # Unpack Anki
    tar -xf anki-2.1.64-linux-qt6.tar.zst
    
    # Change to the unpacked directory
    cd anki-2.1.64-linux-qt6
    
    # Run the install script
    sudo ./install.sh
    
    # Return to the previous directory
    cd ..
    
    # Clean up downloaded files
    rm anki-2.1.64-linux-qt6.tar.zst
    rm -rf anki-2.1.64-linux-qt6
else
    echo "Anki is already installed."
fi