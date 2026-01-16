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
- Use axis-aligned bounding box (RectsIntersect) helper in Components/GameCanvas for simple collision detection between entities
- Call InvokeAsync(StateHasChanged) after performing canvas-based Render operations to ensure Blazor markup (score/lives UI) updates in sync with the canvas loop
- Prefer extracting shared game state (score, lives, wave) into a GameState service for cross-component access rather than keeping only in GameCanvas
- Use the WebAudio API for lightweight sound effects; centralize playback in an AudioService and register it in Program.cs for DI.
