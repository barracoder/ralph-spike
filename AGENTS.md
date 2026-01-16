# AGENTS.md ────────────────────────────────────────────────────────────────

# Persistent instructions & learnings for all AI agents (Ralph, Cursor, Copilot, Claude Code, etc.)

## General Rules

- Never commit directly to main — always use feature branches (ralph-[task-slug])
- Run tests, type checks, lint before every commit
- Prefer smallest possible changes that pass acceptance criteria
- Update this file ONLY with general, reusable lessons (no task-specific notes)

## Project-Specific Gotchas

- prd.json must be an object with `branchName` at root, not a plain array — ralph.sh reads `.branchName` for branch tracking
- prd.json lives in `scripts/ralph/prd.json`, not project root
- Use `${var,,}` lowercase syntax only in Bash 4+ — macOS ships Bash 3.2, use `tr` instead
