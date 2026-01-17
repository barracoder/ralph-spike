#!/bin/bash
# ASCII art and banner functions for Ralph Wiggum
# Copyright (c) 2024-2026 Mark Green, 3I Systems Ltd

# Small icon for inline use
RALPH_ICON=' (~_~) '

# Large ASCII art banner - Ralph Wiggum's face
ralph_banner_large() {
  cat << 'RALPH'
        _______________
       /               \
      /  ~~~~~~~~~~~    \
     |   __     __      |
     |  (oo)   (oo)     |
     |       <          |
     |     (---)        |
     |      \___/       |
      \                /
       \______________/
         ||       ||
         ||_______||
RALPH
}

# Medium banner with quote
ralph_banner_medium() {
  cat << 'RALPH'
        _______________
       /               \
      /  ~~~~~~~~~~~    \
     |   __     __      |
     |  (oo)   (oo)     |
     |       <          |
     |     (---)        |
      \     \___/      /
       \______________/

  "Me fail English? That's unpossible!"
RALPH
}

# Small icon banner
ralph_banner_small() {
  echo '  (~_~)'
  echo '   /|\'
  echo '  / | \'
}

# Success/celebration variant
ralph_success() {
  cat << 'RALPH'
    \(^_^)/
     /|\      "I'm helping!"
    / | \
    
   ✓ Ralph completed all tasks!
RALPH
}

# Error/sad variant
ralph_error() {
  cat << 'RALPH'
   (;_;)
    /|\     "My cat's breath smells like cat food..."
   / | \
RALPH
}

# Thinking variant for iterations
ralph_thinking() {
  echo '  (~_~)  ═══════════════════════════════════════════════════════'
}

# Startup banner with copyright
ralph_startup_banner() {
  echo ""
  ralph_banner_large
  echo ""
  echo "  Copyright (c) 2024-2026 Mark Green, 3I Systems Ltd"
  echo ""
}

# Iteration header
ralph_iteration_header() {
  local iteration=$1
  local max_iterations=$2
  echo ""
  ralph_thinking
  echo "         Ralph Iteration $iteration of $max_iterations"
  echo "         ═══════════════════════════════════════════════════════"
}

# Export functions for use in other scripts
export -f ralph_banner_large
export -f ralph_banner_medium
export -f ralph_banner_small
export -f ralph_success
export -f ralph_error
export -f ralph_thinking
export -f ralph_startup_banner
export -f ralph_iteration_header
