#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles/tostow"

# Check if inotifywait is installed and available
if command -v inotifywait >/dev/null 2>&1 || type inotifywait >/dev/null 2>&1; then
  # Watch for changes in the .dotfiles folder and run stow
  while inotifywait -r -e modify,create,delete,move "$DOTFILES_DIR"; do
    run_stow
  done
else
  echo "inotifywait is not installed or not available. Please install it to use this script."
fi

