#!/bin/bash

todo_file="todo.xit"
inbox_section="Inbox"

if [ $# -eq 0 ]; then
  echo "Please provide a task description."
else
  task_description="$*"

  # Find the line number of the Inbox section
  inbox_line=$(grep -n "$inbox_section" "$todo_file" | cut -d ':' -f 1)
  
  if [ -z "$inbox_line" ]; then
    echo "Inbox section not found in the todo file."
  else
    # Calculate the line number where the new task should be added
    task_line=$((inbox_line + 2))

    # Insert the task at the appropriate line number
    sed -i "${task_line}i[ ] $task_description" "$todo_file"
    echo "Task '$task_description' added to Inbox."
  fi
fi
