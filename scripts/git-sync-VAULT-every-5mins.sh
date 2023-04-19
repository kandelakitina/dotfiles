#!/bin/bash

# Your repository path
REPO_PATH="$HOME/VAULT"

# Your remote name (usually "origin")
REMOTE="origin"

# Your main branch name (usually "main" or "master")
BRANCH="master"

# Sync interval in seconds (5 minutes = 300 seconds)
SYNC_INTERVAL=300

cd $REPO_PATH

# Function to sync changes with GitHub
sync_changes() {
  git add .
  git commit -m "Automatic sync commit"
  git pull --rebase $REMOTE $BRANCH
  git push $REMOTE $BRANCH
}

# Sync every 5 minutes
while true; do
  echo "Syncing with GitHub..."
  sync_changes
  sleep $SYNC_INTERVAL
done