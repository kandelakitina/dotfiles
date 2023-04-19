#!/bin/bash

# Your repository path
REPO_PATH="$HOME/VAULT"

# Your remote name (usually "origin")
REMOTE="origin"

# Your main branch name (usually "main" or "master")
BRANCH="master"

cd $REPO_PATH

# Function to sync changes with GitHub
sync_changes() {
  git add .
  git commit -m "Automatic sync commit"
  git pull --rebase $REMOTE $BRANCH
  git push $REMOTE $BRANCH
}

# Watch for changes and sync when detected
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  inotifywait -m -r -e modify -e create -e delete --exclude '.git' --format '%w%f' $REPO_PATH | while read FILE
  do
    echo "Change detected in $FILE. Syncing with GitHub..."
    sync_changes
  done
fi
