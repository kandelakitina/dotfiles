#!/bin/bash

# Get the battery percentage for Linux and macOS
if [[ "$(uname)" == "Linux" ]]; then
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
elif [[ "$(uname)" == "Darwin" ]]; then
    battery=$(pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $3 }')
fi

# Set color based on battery percentage
if [[ $battery -lt 10 ]]; then
    color="#[fg=red]"
else
    color="#[fg=default]"
fi

# Display the power icon and battery percentage with color formatting
echo -n "$color"
echo -e "\uf0e7 $battery%"