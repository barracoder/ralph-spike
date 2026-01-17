#!/bin/bash
# Docker entrypoint for Ralph container
# Handles authentication and runs the appropriate Ralph script

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Ralph Docker Container${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"

# Override git config if provided
if [[ -n "$GIT_USER_NAME" ]]; then
  echo -e "${GREEN}Setting git user.name:${NC} $GIT_USER_NAME"
  git config --global user.name "$GIT_USER_NAME"
fi

if [[ -n "$GIT_USER_EMAIL" ]]; then
  echo -e "${GREEN}Setting git user.email:${NC} $GIT_USER_EMAIL"
  git config --global user.email "$GIT_USER_EMAIL"
fi

# Determine Ralph script location
# Check if running from a submodule setup or root
RALPH_SCRIPT_DIR=""
if [ -d "/workspace/ralph/scripts/ralph" ]; then
  # Submodule setup
  RALPH_SCRIPT_DIR="/workspace/ralph/scripts/ralph"
  echo -e "${GREEN}✓${NC} Found Ralph in submodule location"
elif [ -d "/workspace/scripts/ralph" ]; then
  # Root setup
  RALPH_SCRIPT_DIR="/workspace/scripts/ralph"
  echo -e "${GREEN}✓${NC} Found Ralph in root location"
else
  echo -e "${RED}Error: Could not find Ralph scripts${NC}"
  echo -e "${YELLOW}Expected location: /workspace/ralph/scripts/ralph or /workspace/scripts/ralph${NC}"
  exit 1
fi

# Authenticate based on agent type
AGENT_TYPE=${RALPH_AGENT:-copilot}

if [[ "$AGENT_TYPE" == "copilot" ]]; then
  if [[ -z "$GITHUB_TOKEN" ]]; then
    echo -e "${RED}Error: GITHUB_TOKEN not set${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}Authenticating GitHub CLI...${NC}"
  echo "$GITHUB_TOKEN" | gh auth login --with-token
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} GitHub CLI authenticated"
  else
    echo -e "${RED}Error: Failed to authenticate GitHub CLI${NC}"
    exit 1
  fi
  
  # Run Ralph with Copilot
  RALPH_SCRIPT="$RALPH_SCRIPT_DIR/ralph-copilot.sh"
  ITERATIONS=${MAX_ITERATIONS:-10}
  MODEL=${MODEL:-gpt-5.1-codex}
  
  echo ""
  echo -e "${BLUE}Running Ralph Copilot...${NC}"
  echo -e "${GREEN}Script:${NC} $RALPH_SCRIPT"
  echo -e "${GREEN}Iterations:${NC} $ITERATIONS"
  echo -e "${GREEN}Model:${NC} $MODEL"
  echo ""
  
  exec bash "$RALPH_SCRIPT" "$ITERATIONS" "$MODEL"
  
elif [[ "$AGENT_TYPE" == "amp" ]]; then
  if [[ -z "$AMP_TOKEN" ]]; then
    echo -e "${RED}Error: AMP_TOKEN not set${NC}"
    exit 1
  fi
  
  echo -e "${BLUE}Setting up Amp authentication...${NC}"
  # Amp authentication typically uses environment variable
  export AMP_TOKEN="$AMP_TOKEN"
  echo -e "${GREEN}✓${NC} Amp token configured"
  
  # Run Ralph with Amp
  RALPH_SCRIPT="$RALPH_SCRIPT_DIR/ralph.sh"
  ITERATIONS=${MAX_ITERATIONS:-10}
  
  echo ""
  echo -e "${BLUE}Running Ralph Amp...${NC}"
  echo -e "${GREEN}Script:${NC} $RALPH_SCRIPT"
  echo -e "${GREEN}Iterations:${NC} $ITERATIONS"
  echo ""
  
  exec bash "$RALPH_SCRIPT" "$ITERATIONS"
  
else
  echo -e "${RED}Error: Invalid RALPH_AGENT '$AGENT_TYPE'${NC}"
  echo -e "${YELLOW}Must be 'copilot' or 'amp'${NC}"
  exit 1
fi
