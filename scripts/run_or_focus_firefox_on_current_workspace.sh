#!/bin/bash

# Get the current desktop/workspace number
current_desktop=$(xdotool get_desktop)

# Search for a Firefox window in the current desktop
win_ids=$(wmctrl -lx | awk -v desktop="$current_desktop" '$2 == desktop && /Navigator.Firefox-esr/ {print $1}')

# Choose the first window ID if multiple are found
win_id=$(echo "$win_ids" | head -n1)

# Check if a Firefox window was found
if [[ -n $win_id ]]; then
    # Activate the window
    xdotool windowactivate "$win_id"
else
    # Start Firefox if no window was found
    firefox-esr &
fi
