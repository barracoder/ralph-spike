#!/bin/bash
# Ralph Docker Runner - Run Ralph in isolated Docker containers
# Usage: ./ralph-docker.sh [copilot|amp] [max_iterations] [model]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
AGENT_TYPE=${1:-copilot}
MAX_ITERATIONS=${2:-10}
MODEL=${3:-gpt-5.1-codex}

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Ralph Docker Runner${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Agent:${NC} $AGENT_TYPE"
echo -e "${GREEN}Iterations:${NC} $MAX_ITERATIONS"
echo -e "${GREEN}Model:${NC} $MODEL"
echo ""

# Validate agent type
if [[ "$AGENT_TYPE" != "copilot" && "$AGENT_TYPE" != "amp" ]]; then
  echo -e "${RED}Error: Invalid agent type '$AGENT_TYPE'${NC}"
  echo -e "${YELLOW}Usage: $0 [copilot|amp] [max_iterations] [model]${NC}"
  exit 1
fi

# Validate required environment variables
if [[ "$AGENT_TYPE" == "copilot" ]]; then
  if [[ -z "$GITHUB_TOKEN" ]]; then
    echo -e "${RED}Error: GITHUB_TOKEN environment variable is required for Copilot${NC}"
    echo -e "${YELLOW}Set it with: export GITHUB_TOKEN=your_token${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓${NC} GITHUB_TOKEN found"
elif [[ "$AGENT_TYPE" == "amp" ]]; then
  if [[ -z "$AMP_TOKEN" ]]; then
    echo -e "${RED}Error: AMP_TOKEN environment variable is required for Amp${NC}"
    echo -e "${YELLOW}Set it with: export AMP_TOKEN=your_token${NC}"
    exit 1
  fi
  echo -e "${GREEN}✓${NC} AMP_TOKEN found"
fi

# Build Docker image
echo ""
echo -e "${BLUE}Building Docker image...${NC}"
docker build -t ralph-runner "$SCRIPT_DIR"

if [ $? -ne 0 ]; then
  echo -e "${RED}Error: Failed to build Docker image${NC}"
  exit 1
fi
echo -e "${GREEN}✓${NC} Docker image built successfully"

# Prepare environment variables for container
ENV_ARGS=""
if [[ "$AGENT_TYPE" == "copilot" ]]; then
  ENV_ARGS="-e GITHUB_TOKEN=$GITHUB_TOKEN -e RALPH_AGENT=copilot"
else
  ENV_ARGS="-e AMP_TOKEN=$AMP_TOKEN -e RALPH_AGENT=amp"
fi

# Add optional git config
if [[ -n "$GIT_USER_NAME" ]]; then
  ENV_ARGS="$ENV_ARGS -e GIT_USER_NAME=$GIT_USER_NAME"
fi
if [[ -n "$GIT_USER_EMAIL" ]]; then
  ENV_ARGS="$ENV_ARGS -e GIT_USER_EMAIL=$GIT_USER_EMAIL"
fi

# Add iteration and model config
ENV_ARGS="$ENV_ARGS -e MAX_ITERATIONS=$MAX_ITERATIONS -e MODEL=$MODEL"

# Run container
echo ""
echo -e "${BLUE}Starting Ralph container...${NC}"
echo -e "${YELLOW}Working directory: $REPO_ROOT${NC}"
echo ""

docker run --rm -it \
  $ENV_ARGS \
  -v "$REPO_ROOT:/workspace" \
  -v "$HOME/.gitconfig:/root/.gitconfig:ro" \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  ralph-runner

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
  echo -e "${GREEN}✓${NC} Ralph completed successfully"
else
  echo -e "${RED}✗${NC} Ralph exited with code $EXIT_CODE"
fi

exit $EXIT_CODE
