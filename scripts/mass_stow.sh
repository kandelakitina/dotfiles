#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles/tostow"

run_stow() {
  for dir in $(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d); do
    package="$(basename "$dir")"

    # Find all files and directories in the package
    find "$dir" -mindepth 1 | while read -r item; do
      # Remove the prefix of the item path, keeping only the relative path
      rel_item_path="${item#$dir/}"
      
      # Construct the target path for the item
      target_path="$HOME/$rel_item_path"

      # Check if the target path is not a symlink and if it exists, then remove it
      if [[ ! -L "$target_path" && -e "$target_path" ]]; then
        # If it's a file, remove it
        if [[ -f "$target_path" ]]; then
          rm -f "$target_path"
        # If it's a directory and empty, remove it
        elif [[ -d "$target_path" && -z "$(ls -A "$target_path")" ]]; then
          rmdir "$target_path"
        fi
      fi
    done

    # Run stow with the --restow option
    (cd "$DOTFILES_DIR" && stow --restow -t ~ "$package")
  done
}

# Call the run_stow function
run_stow
