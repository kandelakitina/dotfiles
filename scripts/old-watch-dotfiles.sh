#!/bin/bash

DOTFILES_DIR="$HOME/.dotfiles"

run_stow() {
  for dir in $(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d); do
    package="$(basename "$dir")"

    # Find all files in the package and delete them from the target location
    find "$dir" -type f | while read -r file; do
      # Remove the prefix of the file path, keeping only the relative path
      rel_file_path="${file#$dir/}"
      
      # Construct the target path for the file
      target_path="$HOME/$rel_file_path"

      # Check if the target path is not a symlink and if it exists, then remove it
      if [[ ! -L "$target_path" && -e "$target_path" ]]; then
        rm -f "$target_path"
      fi
    done

    # Run stow with the --restow option
    (cd "$DOTFILES_DIR" && stow --restow "$package")
  done
}

# Call the run_stow function
run_stow

#!/bin/bash

# Check if inotifywait is installed and available
if command -v inotifywait >/dev/null 2>&1 || type inotifywait >/dev/null 2>&1; then
  # Watch for changes in the .dotfiles folder and run stow
  while inotifywait -r -e modify,create,delete,move "$DOTFILES_DIR"; do
    run_stow
  done
else
  echo "inotifywait is not installed or not available. Please install it to use this script."
fi
