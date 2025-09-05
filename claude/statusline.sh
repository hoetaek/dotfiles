#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Get current directory from workspace
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')

# Get just the directory name (not full path)
dir_name=$(basename "$current_dir")

# Get git branch if we're in a git repository
git_branch=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch=" on $branch"
    fi
fi

# Create colorful status line using printf with ANSI color codes
# Cyan for directory, magenta for git branch
printf "\033[1;36m%s\033[0m\033[1;35m%s\033[0m" "$dir_name" "$git_branch"