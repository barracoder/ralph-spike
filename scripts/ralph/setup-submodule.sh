#!/bin/bash
# Ralph Submodule Setup Script
# Adds ralph-spike as a git submodule and sets up wrapper scripts and templates
# Usage: ./setup-submodule.sh [target-directory]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Target directory (defaults to current directory)
TARGET_DIR=${1:-.}
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}  Ralph Submodule Setup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Target directory:${NC} $TARGET_DIR"
echo ""

# Check if target is a git repository
if [ ! -d "$TARGET_DIR/.git" ]; then
  echo -e "${RED}Error: $TARGET_DIR is not a git repository${NC}"
  echo -e "${YELLOW}Initialize with: git init${NC}"
  exit 1
fi

cd "$TARGET_DIR"

# Step 1: Add ralph-spike as submodule
echo -e "${BLUE}Step 1: Adding ralph-spike as git submodule...${NC}"
if [ -d "ralph" ]; then
  echo -e "${YELLOW}Warning: ralph directory already exists${NC}"
  if [ -d "ralph/.git" ]; then
    echo -e "${GREEN}✓${NC} ralph submodule already configured"
  else
    echo -e "${RED}Error: ralph directory exists but is not a submodule${NC}"
    echo -e "${YELLOW}Please remove or rename the existing ralph directory${NC}"
    exit 1
  fi
else
  git submodule add https://github.com/barracoder/ralph-spike.git ralph
  git submodule update --init --recursive
  echo -e "${GREEN}✓${NC} Submodule added successfully"
fi

# Step 2: Create wrapper script
echo ""
echo -e "${BLUE}Step 2: Creating run-ralph.sh wrapper script...${NC}"
if [ -f "run-ralph.sh" ]; then
  echo -e "${YELLOW}Warning: run-ralph.sh already exists, skipping${NC}"
else
  cat > run-ralph.sh << 'EOF'
#!/bin/bash
# Ralph wrapper script - delegates to ralph submodule
# Usage: ./run-ralph.sh [copilot|amp] [max_iterations] [model]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RALPH_DIR="$SCRIPT_DIR/ralph/scripts/ralph"

if [ ! -d "$RALPH_DIR" ]; then
  echo "Error: Ralph submodule not found at $RALPH_DIR"
  echo "Run: git submodule update --init --recursive"
  exit 1
fi

AGENT_TYPE=${1:-copilot}

if [[ "$AGENT_TYPE" == "copilot" ]]; then
  exec "$RALPH_DIR/ralph-copilot.sh" "${2:-10}" "${3:-gpt-5.1-codex}"
elif [[ "$AGENT_TYPE" == "amp" ]]; then
  exec "$RALPH_DIR/ralph.sh" "${2:-10}"
else
  echo "Usage: $0 [copilot|amp] [max_iterations] [model]"
  exit 1
fi
EOF
  chmod +x run-ralph.sh
  echo -e "${GREEN}✓${NC} Created run-ralph.sh"
fi

# Step 3: Create scripts directory and PRD template
echo ""
echo -e "${BLUE}Step 3: Creating scripts directory structure...${NC}"
mkdir -p scripts/ralph

if [ -f "scripts/ralph/prd.json" ]; then
  echo -e "${YELLOW}Warning: scripts/ralph/prd.json already exists, skipping${NC}"
else
  cat > scripts/ralph/prd.json << 'EOF'
{
  "branchName": "ralph/your-feature",
  "projectName": "Your Project Name",
  "stories": [
    {
      "id": 1,
      "category": "setup",
      "title": "Project setup",
      "description": "Initialize project structure and dependencies",
      "acceptance_criteria": [
        "Project builds successfully",
        "All dependencies installed"
      ],
      "verification_steps": [
        "Build command succeeds"
      ],
      "passes": false
    }
  ]
}
EOF
  echo -e "${GREEN}✓${NC} Created scripts/ralph/prd.json template"
fi

# Step 4: Create PRD markdown template
echo ""
echo -e "${BLUE}Step 4: Creating PRD markdown template...${NC}"
if [ -f "scripts/PRD.md" ]; then
  echo -e "${YELLOW}Warning: scripts/PRD.md already exists, skipping${NC}"
else
  cat > scripts/PRD.md << 'EOF'
# Product Requirements Document

## Project: [Project Name]

**Branch**: `ralph/[feature-name]`

## Overview

[Brief description of what this feature/project accomplishes]

## User Stories

### Story 1: [Setup/Core Feature]

**Category**: setup/core/feature/polish/ui

**Description**: [What needs to be built]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Verification Steps**:
- Command to verify (e.g., `npm test`)
- Manual verification steps

---

### Story 2: [Next Feature]

**Category**: core

**Description**: [What needs to be built]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

**Verification Steps**:
- Verification command
- Manual test steps

---

## Technical Notes

- Dependencies: [List any required packages/tools]
- Technology stack: [e.g., .NET 8, Node.js, Python]
- Testing approach: [Unit tests, integration tests, etc.]

## Success Criteria

Project is complete when:
- [ ] All user stories pass acceptance criteria
- [ ] All tests pass
- [ ] Code builds without errors
- [ ] Documentation is complete
EOF
  echo -e "${GREEN}✓${NC} Created scripts/PRD.md template"
fi

# Step 5: Create or update AGENTS.md
echo ""
echo -e "${BLUE}Step 5: Setting up AGENTS.md...${NC}"
if [ -f "AGENTS.md" ]; then
  echo -e "${YELLOW}Warning: AGENTS.md already exists, skipping${NC}"
else
  cat > AGENTS.md << 'EOF'
# AGENTS.md

# Persistent instructions & learnings for all AI agents (Ralph, Cursor, Copilot, Claude Code, etc.)

## General Rules

- Never commit directly to main — always use feature branches (ralph-[task-slug])
- Run tests, type checks, lint before every commit
- Prefer smallest possible changes that pass acceptance criteria
- Update this file ONLY with general, reusable lessons (no task-specific notes)

## Project-Specific Gotchas

- prd.json must be an object with `branchName` at root, not a plain array — ralph.sh reads `.branchName` for branch tracking
- prd.json lives in `scripts/ralph/prd.json`, not project root
EOF
  echo -e "${GREEN}✓${NC} Created AGENTS.md"
fi

# Step 6: Update .gitignore
echo ""
echo -e "${BLUE}Step 6: Updating .gitignore...${NC}"
if ! grep -q "# Ralph / Agent temp files" .gitignore 2>/dev/null; then
  cat >> .gitignore << 'EOF'

# Ralph / Agent temp files
.ralph/
ralph-*.log
progress.txt.bak
*.env
EOF
  echo -e "${GREEN}✓${NC} Updated .gitignore"
else
  echo -e "${YELLOW}Warning: .gitignore already contains Ralph entries${NC}"
fi

# Step 7: Create .env.example
echo ""
echo -e "${BLUE}Step 7: Creating .env.example...${NC}"
if [ -f ".env.example" ]; then
  echo -e "${YELLOW}Warning: .env.example already exists, skipping${NC}"
else
  cat > .env.example << 'EOF'
# GitHub Authentication (for Copilot)
GITHUB_TOKEN=your_github_token_here

# Amp Authentication
AMP_TOKEN=your_amp_token_here

# Git Configuration (optional, for Docker)
GIT_USER_NAME=Your Name
GIT_USER_EMAIL=your.email@example.com

# Ralph Configuration
MAX_ITERATIONS=10
MODEL=gpt-5.1-codex
EOF
  echo -e "${GREEN}✓${NC} Created .env.example"
fi

# Final summary
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Created/Updated:${NC}"
echo "  - ralph/ (git submodule)"
echo "  - run-ralph.sh (wrapper script)"
echo "  - scripts/ralph/prd.json (PRD template)"
echo "  - scripts/PRD.md (PRD markdown template)"
echo "  - AGENTS.md (agent instructions)"
echo "  - .gitignore (Ralph artifacts)"
echo "  - .env.example (environment template)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Copy .env.example to .env and add your tokens"
echo "  2. Edit scripts/PRD.md with your requirements"
echo "  3. Use an AI agent to convert PRD.md to prd.json"
echo "  4. Run: ./run-ralph.sh copilot"
echo ""
echo -e "${BLUE}For more information, see: ralph/SUBMODULE_USAGE.md${NC}"
