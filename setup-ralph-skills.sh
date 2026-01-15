#!/usr/bin/env bash
set -euo pipefail

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

mkdir -p "$RALPH_DIR" "$SKILLS_DIR"

# ──────────────────────────────────────────────────────────────────────────────
# Download ralph.sh + prompt.md (using snarktank/ralph as stable base)
# You can swap URL to frankbria/ralph-claude-code or iannuttall/ralph if preferred
# ──────────────────────────────────────────────────────────────────────────────

echo "→ Downloading ralph.sh & prompt.md ..."

curl -sSL -o "$RALPH_DIR/ralph.sh" \
  https://raw.githubusercontent.com/snarktank/ralph/main/ralph.sh

curl -sSL -o "$RALPH_DIR/prompt.md" \
  https://raw.githubusercontent.com/snarktank/ralph/main/prompt.md

chmod +x "$RALPH_DIR/ralph.sh"

# If you prefer frankbria's version (more features in 2026 forks):
# curl -sSL -o "$RALPH_DIR/ralph.sh" https://raw.githubusercontent.com/frankbria/ralph-claude-code/main/ralph_loop.sh
# etc.

# ──────────────────────────────────────────────────────────────────────────────
# Create AGENTS.md skeleton (persistent learnings + rules)
# ──────────────────────────────────────────────────────────────────────────────

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

echo "→ Created $AGENTS_FILE"

# ──────────────────────────────────────────────────────────────────────────────
# Create example prd.json skeleton
# ──────────────────────────────────────────────────────────────────────────────

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

echo "→ Created example $PRD_JSON — replace with your real PRD"

# ──────────────────────────────────────────────────────────────────────────────
# Skills ─ each in its own folder with SKILL.md
# ──────────────────────────────────────────────────────────────────────────────

declare -A skills=(
  ["ralph-setup"]="Initialize or repair Ralph loop structure"
  ["prd"]="Generate/refine/validate structured PRDs → JSON tasks"
  ["back-pressure"]="Enforce test/type/lint gates before commits"
  ["commit-convention"]="Use conventional commits with scope & verification"
  ["code-review"]="Self-review changes for quality/security/readability"
  ["test-architect"]="Write high-coverage tests (TDD preferred)"
  ["learnings-updater"]="Append general lessons to AGENTS.md"
  ["progress-logger"]="Maintain progress.txt with failures & patterns"
  ["circuit-breaker"]="Detect stalled loops & halt"
  ["cleanup"]="Clean temp files/branches after loop"
)

for skill in "${!skills[@]}"; do
  mkdir -p "$SKILLS_DIR/$skill"
  cat > "$SKILLS_DIR/$skill/SKILL.md" << EOF
---
name: $skill
description: ${skills[$skill]}
metadata:
  short-description: ${skills[$skill],,}
---

# $skill Skill

## When to use
Use this skill when the task involves ${skill//-/ } or related concerns.

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

  echo "→ Created skill: $skill"
done

# ──────────────────────────────────────────────────────────────────────────────
# .gitignore additions (optional but recommended)
# ──────────────────────────────────────────────────────────────────────────────

if [[ -f .gitignore ]]; then
  cat >> .gitignore << 'EOF'

# Ralph / Agent temp files
.ralph/
ralph-*.log
progress.txt.bak
EOF
else
  echo "# Ralph / Agent temp" > .gitignore
  echo ".ralph/" >> .gitignore
  echo "ralph-*.log" >> .gitignore
  echo "progress.txt.bak" >> .gitignore
fi

echo "→ Updated .gitignore"

# ──────────────────────────────────────────────────────────────────────────────
# Final instructions
# ──────────────────────────────────────────────────────────────────────────────

cat << 'EOF'

Bootstrap complete!

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