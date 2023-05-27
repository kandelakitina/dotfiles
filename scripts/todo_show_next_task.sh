#!/bin/bash

file_path="$HOME/VAULT/TODOs/todo.xit"

# Extract the lines starting with [ ]
todo_items=()
while IFS= read -r line; do
    if [[ "$line" == "[ ]"* ]]; then
        todo_items+=("$line")
    fi
done < "$file_path"

# Filter the items with exclamation marks
important_items=()
for item in "${todo_items[@]}"; do
    if [[ "$item" == *"!"* ]]; then
        important_items+=("$item")
    fi
done

if (( ${#important_items[@]} > 0 )); then
    # Find the item with the most exclamation marks
    max_count=0
    for item in "${important_items[@]}"; do
        count=$(grep -o '!' <<< "$item" | wc -l)
        if (( count > max_count )); then
            max_count=$count
        fi
    done

    # Print the item(s) with the most exclamation marks (trimmed)
    # echo "Item(s) with the most '!' marks:"
    for item in "${important_items[@]}"; do
        count=$(grep -o '!' <<< "$item" | wc -l)
        if (( count == max_count )); then
            echo "${item:3}"
        fi
    done
else
    # If there are no items with exclamation marks, select a random item (trimmed)
    if (( ${#todo_items[@]} > 0 )); then
        # echo "No items with '!' marks. Selecting a random item:"
        random_item=${todo_items[RANDOM % ${#todo_items[@]}]}
        echo "${random_item:3}"
    else
        echo "No items starting with '[ ]' found."
    fi
fi
