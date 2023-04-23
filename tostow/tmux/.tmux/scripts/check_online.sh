#!/bin/bash

# Check if the computer is online by pinging a reliable host
ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Online"
else
    echo "#[fg=red]Offline"
fi
