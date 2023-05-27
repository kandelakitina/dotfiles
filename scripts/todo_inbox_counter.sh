#!/bin/bash

directory="$HOME/VAULT/TODOs"
filename="$directory/todo.xit"

count=0
empty_lines=0

while IFS= read -r line; do
    line=$(echo "$line" | awk '{$1=$1};1')  # Trim leading/trailing whitespace
    if [[ $line == '[ ]'* ]]; then
        ((count++))
    elif [[ -z $line ]]; then
        ((empty_lines++))
        if ((empty_lines == 2)); then
            break
        fi
    fi
done < "$filename"

echo "$count"

