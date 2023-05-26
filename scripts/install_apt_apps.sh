#!/bin/bash

# Check if Goldendict is installed
if ! command -v goldendict &> /dev/null; then
    echo "Goldendict is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y goldendict
else
    echo "Goldendict is already installed."
fi

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