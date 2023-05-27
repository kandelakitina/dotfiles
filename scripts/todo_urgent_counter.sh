#!/bin/bash

directory="$HOME/VAULT/TODOs"
filename="$directory/todo.xit"

count=0

while IFS= read -r line; do
    line=$(echo "$line" | awk '{$1=$1};1')  # Trim leading/trailing whitespace
    if [[ $line == '[ ]'* && $line == *'!'* ]]; then
        ((count++))
    fi
done < "$filename"

echo "$count"

