#!/bin/bash
stow_dir="$HOME/dotfiles/tostow"
cd "$stow_dir"
for dir in */; do
    if [ -d "$dir" ]; then
        stow -t "$HOME" "$dir"
    fi
done
