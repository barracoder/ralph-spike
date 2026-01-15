#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}→${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }

echo "============================================================="
echo "  Ralph + Skills Bootstrapper (for Mark @MobiusSlit) - 2026 "
echo "  Sets up ralph.sh loop + .github/skills/ with core skills  "
echo "============================================================="

# ──────────────────────────────────────────────────────────────────────────────
# Config / directories
# ──────────────────────────────────────────────────────────────────────────────

RALPH_DIR="scripts/ralph"
SKILLS_DIR=".github/skills"
AGENTS_FILE="AGENTS.md"
PRD_JSON="prd.json"

# Check for curl
if ! command -v curl &> /dev/null; then
  error "curl is required but not installed"
  exit 1
fi

mkdir -p "$RALPH_DIR" "$SKILLS_DIR"

# ──────────────────────────────────────────────────────────────────────────────
# Download ralph.sh + prompt.md (using snarktank/ralph as stable base)
# You can swap URL to frankbria/ralph-claude-code or iannuttall/ralph if preferred
# ──────────────────────────────────────────────────────────────────────────────

RALPH_REPO="${RALPH_REPO:-snarktank/ralph}"
RALPH_BRANCH="${RALPH_BRANCH:-main}"
RALPH_BASE_URL="https://raw.githubusercontent.com/${RALPH_REPO}/${RALPH_BRANCH}"

info "Downloading ralph.sh & prompt.md from ${RALPH_REPO}..."

if ! curl -fsSL -o "$RALPH_DIR/ralph.sh" "${RALPH_BASE_URL}/ralph.sh"; then
  error "Failed to download ralph.sh"
  exit 1
fi

if ! curl -fsSL -o "$RALPH_DIR/prompt.md" "${RALPH_BASE_URL}/prompt.md"; then
  error "Failed to download prompt.md"
  exit 1
fi

chmod +x "$RALPH_DIR/ralph.sh"
info "Downloaded and made executable: $RALPH_DIR/ralph.sh"

# If you prefer frankbria's version (more features in 2026 forks):
# curl -sSL -o "$RALPH_DIR/ralph.sh" https://raw.githubusercontent.com/frankbria/ralph-claude-code/main/ralph_loop.sh
# etc.

# ──────────────────────────────────────────────────────────────────────────────
# Create AGENTS.md skeleton (persistent learnings + rules)
# ──────────────────────────────────────────────────────────────────────────────

if [[ -f "$AGENTS_FILE" ]]; then
  warn "$AGENTS_FILE already exists — skipping (won't overwrite)"
else
  cat > "$AGENTS_FILE" << 'EOF'
# AGENTS.md ────────────────────────────────────────────────────────────────
# Persistent instructions & learnings for all AI agents (Ralph, Cursor, Copilot, Claude Code, etc.)

## General Rules
- Never commit directly to main — always use feature branches (ralph-[task-slug])
- Run tests, type checks, lint before every commit
- Prefer smallest possible changes that pass acceptance criteria
- Update this file ONLY with general, reusable lessons (no task-specific notes)

## Project-Specific Gotchas
# (Agent will append here via learnings-updater skill)

EOF
  info "Created $AGENTS_FILE"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Create example prd.json skeleton
# ──────────────────────────────────────────────────────────────────────────────

if [[ -f "$PRD_JSON" ]]; then
  warn "$PRD_JSON already exists — skipping (won't overwrite)"
else
  cat > "$PRD_JSON" << 'EOF'
[
  {
    "id": 1,
    "category": "setup",
    "title": "Initialize README and basic structure",
    "description": "Create README.md with project overview, install instructions, and running Ralph",
    "acceptance_criteria": ["README exists", "Contains quickstart for Ralph"],
    "verification_steps": ["cat README.md"],
    "passes": false
  },
  {
    "id": 2,
    "category": "core",
    "title": "Add hello world endpoint (example)",
    "description": "Implement /hello endpoint that returns JSON {message: 'Hello from Ralph'}",
    "acceptance_criteria": ["Endpoint works", "Tests pass"],
    "verification_steps": ["curl localhost:3000/hello"],
    "passes": false
  }
]
EOF
  info "Created example $PRD_JSON — replace with your real PRD"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Skills ─ each in its own folder with SKILL.md
# ──────────────────────────────────────────────────────────────────────────────

# Define skills as a simple list (avoids associative array issues with set -u)
# Format: "skill-name|description"
SKILLS=(
  "ralph-setup|Initialize or repair Ralph loop structure"
  "prd|Generate/refine/validate structured PRDs → JSON tasks"
  "back-pressure|Enforce test/type/lint gates before commits"
  "commit-convention|Use conventional commits with scope & verification"
  "code-review|Self-review changes for quality/security/readability"
  "test-architect|Write high-coverage tests (TDD preferred)"
  "learnings-updater|Append general lessons to AGENTS.md"
  "progress-logger|Maintain progress.txt with failures & patterns"
  "circuit-breaker|Detect stalled loops & halt"
  "cleanup|Clean temp files/branches after loop"
)

for entry in "${SKILLS[@]}"; do
  skill="${entry%%|*}"
  description="${entry#*|}"
  skill_dir="$SKILLS_DIR/$skill"
  skill_file="$skill_dir/SKILL.md"
  
  mkdir -p "$skill_dir"
  
  if [[ -f "$skill_file" ]]; then
    warn "Skill $skill already exists — skipping"
    continue
  fi
  
  # Convert skill name to readable form (replace hyphens with spaces)
  readable_skill="${skill//-/ }"
  # Lowercase description for metadata (compatible with Bash 3.2+)
  lowercase_desc=$(echo "$description" | tr '[:upper:]' '[:lower:]')
  
  cat > "$skill_file" << EOF
---
name: $skill
description: $description
metadata:
  short-description: $lowercase_desc
---

# $skill Skill

## When to use
Use this skill when the task involves $readable_skill or related concerns.

## Core Instructions
- Follow project conventions from AGENTS.md
- Enforce strong back-pressure: tests must pass before commit
- For frontend tasks: verify visually (use dev-browser if available)
- Log learnings to AGENTS.md only if general/reusable
- If stuck after 3 attempts: abandon and note failure

## Verification
Always run appropriate checks:
- \`npm test\` / \`pytest\` / \`cargo test\` etc.
- Type check (tsc --noEmit, pyright, mypy...)
- Lint & format

EOF

  info "Created skill: $skill"
done

# ──────────────────────────────────────────────────────────────────────────────
# .gitignore additions (optional but recommended)
# ──────────────────────────────────────────────────────────────────────────────

GITIGNORE_ENTRIES="
# Ralph / Agent temp files
.ralph/
ralph-*.log
progress.txt.bak
"

if [[ -f .gitignore ]]; then
  # Only append if not already present
  if ! grep -q "Ralph / Agent temp" .gitignore 2>/dev/null; then
    echo "$GITIGNORE_ENTRIES" >> .gitignore
    info "Updated .gitignore with Ralph entries"
  else
    warn ".gitignore already has Ralph entries — skipping"
  fi
else
  echo "$GITIGNORE_ENTRIES" > .gitignore
  info "Created .gitignore with Ralph entries"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Final instructions
# ──────────────────────────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}✓ Bootstrap complete!${NC}"
cat << 'EOF'

Next steps:

1. Customize prd.json with your real tasks (or ask agent: "Load prd skill and convert my markdown PRD to JSON")

2. Run Ralph (examples):

   # Claude Code / Amp style
   ./scripts/ralph/ralph.sh claude --dangerously-skip-permissions

   # Or Copilot CLI / Codex style
   ./scripts/ralph/ralph.sh codex exec --yolo -

   # With iteration limit
   ./scripts/ralph/ralph.sh claude ... 20

3. First prompt suggestion:
   "Load ralph-setup skill → initialize if needed, then load prd skill and start working on task id 1"

4. Optional: symlink for reuse across repos
   ln -s ~/dotsettings/.github/skills/* .github/skills/   (if you keep dotsettings repo)

Happy shipping — let Ralph do the heavy lifting!

EOF