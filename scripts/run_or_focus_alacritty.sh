#!/bin/bash

# Check if Alacritty is running
if pgrep -x "alacritty" > /dev/null; then
  # Get the window ID of the first Alacritty instance
  ALACRITTY_WID=$(xdotool search --onlyvisible --class alacritty | head -1)
  
  # Get the current workspace ID
  CURRENT_WORKSPACE=$(xdotool get_desktop)
  
  # Activate the Alacritty window if a valid window ID is found
  if [ -n "$ALACRITTY_WID" ]; then
    # Move Alacritty to the current workspace
    xdotool set_desktop_for_window "$ALACRITTY_WID" "$CURRENT_WORKSPACE"
    # Activate the Alacritty window
    xdotool windowactivate "$ALACRITTY_WID"
  else
    nixGLIntel alacritty &
  fi
else
  # Start a new Alacritty instance if not running
  nixGLIntel alacritty &
fi
