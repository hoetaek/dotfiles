#!/bin/bash

# Claude Code Custom Status Line Script
# Components: directory, model, git branch/status

# Read JSON input from Claude Code
input=$(cat)

# Extract basic info from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // ""')
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# Change to current directory for git operations
cd "$current_dir" 2>/dev/null || cd /

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# 1. Current Directory
dir_name=$(basename "$current_dir" 2>/dev/null || echo "unknown")

# 2. Model (already extracted)

# 3. Git Branch and Status (lock-safe)
git_info=""
if git rev-parse --git-dir >/dev/null 2>&1; then
    # Use symbolic-ref which doesn't acquire locks
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "detached")
    
    # Simple check for changes using diff commands that don't require index locks
    # Check if there are any differences between HEAD and working tree
    if git diff-index --quiet HEAD 2>/dev/null && git diff-files --quiet 2>/dev/null; then
        git_info=$(printf "\033[0;35m%s \033[0;32m✓\033[0m" "$branch")
    else
        git_info=$(printf "\033[0;35m%s \033[0;31m×\033[0m" "$branch")
    fi
else
    git_info="${PURPLE}no-git${RESET}"
fi

# Assemble final status line
printf "${CYAN}📁 %s${RESET} | ${YELLOW}🤖 %s${RESET} | 🌿 %s" \
    "$dir_name" \
    "$model_name" \
    "$git_info"