#!/bin/bash

# Check if Alacritty is already installed
if ! command -v alacritty &> /dev/null; then
  # Clone Alacritty repo to a temporary folder
  git clone https://github.com/alacritty/alacritty.git /tmp/alacritty

  # Install dependencies
  sudo apt update
  sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

  # Check if cargo is installed, and install it with Nix if not
  if ! command -v cargo &> /dev/null; then
    echo "Installing cargo using Nix package manager..."
    nix-env -iA nixpkgs.cargo
  else
    echo "Cargo is already installed."
  fi

  # Build Alacritty
  cd /tmp/alacritty
  cargo build --release

  # Configure Alacritty
  if ! infocmp alacritty &> /dev/null; then
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
  fi

  # Create desktop entry
  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # Install fish shell completions for Alacritty
  mkdir -p $fish_complete_path[1]
  cp extra/completions/alacritty.fish $fish_complete_path[1]/alacritty.fish

  # Clean up temporary folder
  rm -rf /tmp/alacritty

  echo "Alacritty installation completed."
else
  echo "Alacritty is already installed."
fi
