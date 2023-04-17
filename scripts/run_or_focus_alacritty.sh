#!/bin/bash

# Check if Alacritty is running
if pgrep -x "alacritty" > /dev/null; then
  # Get the window ID of the first Alacritty instance
  ALACRITTY_WID=$(xdotool search --onlyvisible --class alacritty | head -1)
  
  # Activate the Alacritty window if a valid window ID is found
  if [ -n "$ALACRITTY_WID" ]; then
    xdotool windowactivate "$ALACRITTY_WID"
  else
    alacritty &
  fi
else
  # Start a new Alacritty instance if not running
  alacritty &
fi
