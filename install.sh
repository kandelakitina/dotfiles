#!/bin/bash

# =================
# Nix Package manager
# =================

# Check if nix is installed
if ! command -v nix &> /dev/null; then
  # Install nix and source nix from Determinate Systems
  echo -e "\nNix package manager not found. Installing..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

  # Run nix daemon
  bash /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  bash /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish

else
  echo -e "\nNix package manager is already installed."
fi

# Force add nixpkgs channel to avoid errors
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

# =================
# Stow
# =================

# Check if stow is already installed
if ! command -v stow &>/dev/null; then
    echo "Installing stow"
    nix-env -iA nixpkgs.stow
else
    echo "Stow is already installed"
fi

# Stow config files

echo "Stowing config files"
bash /home/boticelli/dotfiles/scripts/mass_stow.sh

# =================
# Nix packages
# =================

# Array of rainbow colors (in ANSI escape codes)
rainbow_colors=(
  "\033[38;5;196m" # Red
  "\033[38;5;202m" # Orange
  "\033[38;5;226m" # Yellow
  "\033[38;5;46m"  # Green
  "\033[38;5;21m"  # Blue
  "\033[38;5;93m"  # Indigo
  "\033[38;5;201m" # Violet
)

color_index=0

# Associative array with package names as keys and attribute paths as values
declare -A packages

packages=(
  [alacritty]=alacritty
  [bat]=bat
  [direnv]=direnv
  [fd]=fd
  [fish]=fish
  [fzf]=fzf
  [fff]=fff
  [gcc-wrapper]=gcc_multi
  [gh]=gh
  [git]=git
  [entr]=entr
  [exa]=exa
  [helix]=helix
  [html-xml-utils]=html-xml-utils
  [jrnl]=jrnl
  [inotify-tools]=inotify-tools
  [lazygit]=lazygit
  [neovim]=neovim
  [nodejs]=nodejs

  # LSPs and linters
  [deno]=deno
  [bash-language-server]=nodePackages.bash-language-server
  [marksman]=marksman
  [yaml-language-server]=nodePackages.yaml-language-server
  [vscode-langservers-extracted]=nodePackages.vscode-langservers-extracted
  [typescript-language-server]=nodePackages_latest.typescript-language-server
  # [python3]=python311
  # [python3.11-pip]=python311Packages.pip
  # [python3.11-python-lsp-server]=python311Packages.python-lsp-server

  [ripgrep]=ripgrep
  [starship]=starship
  [stow]=stow
  [sxhkd]=sxhkd
  [taskwarrior]=taskwarrior
  [taskwarrior-tui]=taskwarrior-tui
  [trashy]=trashy
  [tree]=tree
  [tmux]=tmux
  [yarn]=yarn
  [urlview]=urlview
  [xdotool]=xdotool
  [xclip]=xclip
  [xmodmap]=xorg.xmodmap
  [zoxide]=zoxide
  [zk]=zk
)

echo -e "\nInstalling Nix packages"

# Installing packages if they are not installed
printf "%s\n" "${!packages[@]}" | sort | while read -r pkg_name; do
  pkg_attr_path="${packages[$pkg_name]}"

  # Check if the package is already installed
  color=${rainbow_colors[$color_index]}
  nix-env -q "${pkg_name}*" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${color}$pkg_name\033[0m is already installed."
  else
    echo -e "Installing ${color}$pkg_name\033[0m"
    nix-env -iA nixpkgs.$pkg_attr_path
  fi

  # Update the color index, cycling through the rainbow colors
  color_index=$(( (color_index + 1) % ${#rainbow_colors[@]} ))
done

# Symlink Nix desktop folder to make Gnome see nix apps
# mkdir -p ~/.local/share
# ln -s ~/.nix-profile/share/applications ~/.local/share/applications
# ln -s ~/.nix-profile/share/icons ~/.local/share/icons

applications_path="$HOME/.local/share/applications"
icons_path="$HOME/.local/share/icons"

# Check if the applications symlink exists
if [ -L "$applications_path" ]; then
    echo -e "\nNix packages' desktop files are already symlinked to system"
else
    # Remove the directory if it exists and is not a symlink
    if [ -d "$applications_path" ]; then
        rm -r "$applications_path"
    fi
    ln -s ~/.nix-profile/share/applications "$applications_path"
    echo -e "\nSymlinked Nix packages' desktop files to system applications"
fi

# Check if the icons symlink exists
if [ -L "$icons_path" ]; then
    echo -e "\nNix packages' icons are already symlinked to system"
else
    # Remove the directory if it exists and is not a symlink
    if [ -d "$icons_path" ]; then
        rm -r "$icons_path"
    fi
    ln -s ~/.nix-profile/share/icons "$icons_path"
    echo -e "\nSymlinked Nix packages' icons to system icons"
fi

# NixGL Video Driver (for alacritty)
####################################

nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update

# Check if nixGLIntel is already installed
if ! nix-env -q nixGLIntel &>/dev/null; then
    echo "Installing nixGLIntel"
    nix-env -iA nixgl.nixGLIntel
else
    echo "nixGLIntel is already installed"
fi

# nix-env -iA nixgl.auto.nixGLDefault   # or replace `nixGLDefault` with your desired wrapper

# =================
# Fish
# =================

# Get the current default shell
current_shell="$SHELL"

# Get the Fish shell path
fish_path=$(which fish)

# Check if Fish is already the default shell
if [ "$current_shell" != "$fish_path" ]; then
    echo -e "\nSetting Fish as the default shell..."

    # Add Fish to valid login shells if it's not there already
    if ! grep -q "^$fish_path$" /etc/shells; then
        echo -e "\nAdding Fish to valid login shells..."
        command -v fish | sudo tee -a /etc/shells
    fi

    # Use Fish as the default shell
    chsh -s "$fish_path"
    echo -e "\nFish is now the default shell."
else
    echo -e "\nFish is already the default shell."
fi

## =================
## Fisher plugins
## =================

# echo -e "\nInstalling Fisher plugins\n"
# color=${rainbow_colors[$color_index]}

# # Check if jethrokuan/z plugin is already installed
# color=${rainbow_colors[$color_index]}

# # z (folder jumping based on 'freceny')
# fish -c 'fisher list | grep -q "jethrokuan/z"'
# if [ $? -eq 0 ]; then
#   echo -e "${color}jethrokuan/z\033[0m plugin is already installed."
# else
#   echo -e "Installing ${color}jethrokuan/z\033[0m plugin"
#   fish -c 'fisher install jethrokuan/z'
# fi
# color_index=$(( (color_index + 1) % ${#rainbow_colors[@]} ))

# =================
# Nerd-Fonts
# =================

font_directory="$HOME/.local/share/fonts"

# Ubuntu Regular
font_file_mono="UbuntuMonoNerdFont-Regular.ttf"
font_url_mono="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/UbuntuMono/Regular/UbuntuMonoNerdFont-Regular.ttf"

# Ubuntu Nerd Font
font_file="UbuntuNerdFont-Regular.ttf"
font_url="https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Ubuntu/Regular/UbuntuNerdFont-Regular.ttf"

# Download and install font function
download_and_install_font() {
    local font_file="$1"
    local font_url="$2"

    if [ ! -f "${font_directory}/${font_file}" ]; then
        echo -e "\nInstalling ${font_file}..."

        # Download and install the font
        mkdir -p "$font_directory"
        cd "$font_directory" && curl -fLo "$font_file" "$font_url"

        # Update the font cache
        fc-cache -f -v

        echo -e "\n${font_file} installed."
    else
        echo -e "\n${font_file} is already installed."
    fi
}

# Download and install both fonts
download_and_install_font "$font_file_mono" "$font_url_mono"
download_and_install_font "$font_file" "$font_url"

# =================
# NPM
# =================

desired_npm_prefix="$HOME/.npm-global"

# Check the current NPM prefix
current_npm_prefix=$(npm config get prefix)

# Run the script only if the desired NPM prefix is not set
if [ "$current_npm_prefix" != "$desired_npm_prefix" ]; then
    echo -e "\nConfiguring NPM to use the desired prefix..."

    # Configure NPM to install in ~/.npm-global, instead of the default folder
    mkdir -p "$desired_npm_prefix"/{lib,bin}
    npm config set prefix "$desired_npm_prefix"

    # Add the new NPM prefix to the PATH
    export PATH="$desired_npm_prefix/bin:$PATH"
    echo -e "\nNPM configured to use the desired prefix."
else
    echo -e "\nNPM is already configured with the desired prefix."
fi

# =================
# Alacritty themes switcher
# =================

# Check if alacritty-themes is already installed
if ! command -v alacritty-themes &> /dev/null; then
    echo -e "\nInstalling alacritty-themes switcher..."

    # Install alacritty themes switcher
    npm i -g alacritty-themes

    echo -e "\nalacritty-themes switcher installed. Use 'at' in CLI to change themes."
else
    echo -e "\nalacritty-themes switcher is already installed."
fi

# =================
# TMUX plugins
# =================

if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo -e "\nInstalling TMUX plugin manager"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo -e "\nTMUX plugin manager already installed"
fi

# =================
# GitHub Login
# =================

# Check if the user is already logged into GitHub
gh auth status > /dev/null 2>&1
auth_status=$?

if [ $auth_status -ne 0 ]; then
    echo -e "\nNot logged into GitHub. Running 'gh auth login'..."
    gh auth login
else
    echo -e "\nAlready logged into GitHub."
fi

# =================
# Git
# =================

git config --global user.email "kandelakitina@gmail.com"
git config --global user.name "boticelli"
