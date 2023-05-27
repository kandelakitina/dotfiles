import os
import random

# Get the absolute path to the todo.xit file
file_path = os.path.expanduser("~/VAULT/TODOs/todo.xit")

with open(file_path, "r") as file:
    content = file.readlines()

# Extract the lines starting with [ ]
todo_items = []
for line in content:
    if line.strip().startswith("[ ]"):
        todo_items.append(line.strip())

# Filter the items with exclamation marks
important_items = [item for item in todo_items if "!" in item]

if important_items:
    # Find the item with the most exclamation marks
    max_count = max(item.count("!") for item in important_items)
    items_with_max_count = [item for item in important_items if item.count("!") == max_count]

    # Print the item(s) with the most exclamation marks (trimmed)
    # print("Item(s) with the most '!' marks:")
    for item in items_with_max_count:
        print(item[3:])  # Trim the '[ ]' from the item
else:
    # If there are no items with exclamation marks, select a random item (trimmed)
    if todo_items:
        # print("No items with '!' marks. Selecting a random item:")
        random_item = random.choice(todo_items)
        print(random_item[3:])  # Trim the '[ ]' from the item
    else:
        print("No todo items are found")
