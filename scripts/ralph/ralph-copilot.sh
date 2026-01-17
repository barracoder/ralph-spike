#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# Ralph - Autonomous AI Coding Agent Workflow
# Copyright (c) 2024-2026 Mark Green, 3I Systems Ltd
# All rights reserved.
#
# This software is provided under license. Unauthorized copying, modification,
# distribution, or use of this software, via any medium, is strictly prohibited.
# ═══════════════════════════════════════════════════════════════════════════════

set -e

MAX_ITERATIONS=${1:-10}
MODEL=${2:-gpt-5.1-codex}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRD_FILE="$SCRIPT_DIR/prd.json"
PROGRESS_FILE="$SCRIPT_DIR/progress.txt"
ARCHIVE_DIR="$SCRIPT_DIR/archive"
LAST_BRANCH_FILE="$SCRIPT_DIR/.last-branch"

# Check for copilot CLI
if ! command -v copilot &>/dev/null; then
  echo "Error: Copilot CLI not found"
  echo "Install from: https://githubnext.com/projects/copilot-cli"
  exit 1
fi

# Archive previous run if branch changed
if [ -f "$PRD_FILE" ] && [ -f "$LAST_BRANCH_FILE" ]; then
  CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")
  LAST_BRANCH=$(cat "$LAST_BRANCH_FILE" 2>/dev/null || echo "")
  
  if [ -n "$CURRENT_BRANCH" ] && [ -n "$LAST_BRANCH" ] && [ "$CURRENT_BRANCH" != "$LAST_BRANCH" ]; then
    # Archive the previous run
    DATE=$(date +%Y-%m-%d)
    # Strip "ralph/" prefix from branch name for folder
    FOLDER_NAME=$(echo "$LAST_BRANCH" | sed 's|^ralph/||')
    ARCHIVE_FOLDER="$ARCHIVE_DIR/$DATE-$FOLDER_NAME"
    
    echo "Archiving previous run: $LAST_BRANCH"
    mkdir -p "$ARCHIVE_FOLDER"
    [ -f "$PRD_FILE" ] && cp "$PRD_FILE" "$ARCHIVE_FOLDER/"
    [ -f "$PROGRESS_FILE" ] && cp "$PROGRESS_FILE" "$ARCHIVE_FOLDER/"
    echo "   Archived to: $ARCHIVE_FOLDER"
    
    # Reset progress file for new run
    echo "# Ralph Progress Log" > "$PROGRESS_FILE"
    echo "Started: $(date)" >> "$PROGRESS_FILE"
    echo "---" >> "$PROGRESS_FILE"
  fi
fi

# Track current branch
if [ -f "$PRD_FILE" ]; then
  CURRENT_BRANCH=$(jq -r '.branchName // empty' "$PRD_FILE" 2>/dev/null || echo "")
  if [ -n "$CURRENT_BRANCH" ]; then
    echo "$CURRENT_BRANCH" > "$LAST_BRANCH_FILE"
  fi
fi

# Initialize progress file if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
  echo "# Ralph Progress Log" > "$PROGRESS_FILE"
  echo "Started: $(date)" >> "$PROGRESS_FILE"
  echo "---" >> "$PROGRESS_FILE"
fi

# Display copyright banner
echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║                    🤖 RALPH - Autonomous Coding Agent                     ║"
echo "║                                                                           ║"
echo "║  Copyright (c) 2024-2026 Mark Green, 3I Systems Ltd. All rights reserved.║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "Starting Ralph (Copilot) - Max iterations: $MAX_ITERATIONS, Model: $MODEL"

for i in $(seq 1 $MAX_ITERATIONS); do
  echo ""
  echo "═══════════════════════════════════════════════════════"
  echo "  Ralph Iteration $i of $MAX_ITERATIONS (Copilot)"
  echo "═══════════════════════════════════════════════════════"
  
  # Read prompt and send to Copilot CLI in non-interactive mode
  PROMPT=$(cat "$SCRIPT_DIR/prompt.md")
  
  # Run copilot with full permissions (--yolo = --allow-all)
  OUTPUT=$(copilot -p "$PROMPT" --yolo --model "$MODEL" 2>&1 | tee /dev/stderr) || true
  
  # Check for completion signal
  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo ""
    echo "Ralph completed all tasks!"
    echo "Completed at iteration $i of $MAX_ITERATIONS"
    exit 0
  fi
  
  echo "Iteration $i complete. Continuing..."
  sleep 2
done

echo ""
echo "Ralph reached max iterations ($MAX_ITERATIONS) without completing all tasks."
echo "Check $PROGRESS_FILE for status."
exit 1
