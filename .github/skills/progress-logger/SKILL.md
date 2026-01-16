---
name: progress-logger
description: Maintain progress.txt with iteration logs and patterns
---

# progress-logger

Maintain `scripts/ralph/progress.txt` with two sections:

## 1. Codebase Patterns (at TOP of file)

Consolidate reusable patterns that future iterations should know:

```markdown
## Codebase Patterns

- Use `RectsIntersect` helper for collision detection
- Call `InvokeAsync(StateHasChanged)` after canvas Render operations
- Export types from actions.ts for UI components
```

Only add **general, reusable** patterns—not story-specific details.

## 2. Iteration Logs (APPEND after each story)

```markdown
## [Date/Time] - [Story ID]

Thread: https://ampcode.com/threads/{thread-id}

- What was implemented
- Files changed
- **Learnings for future iterations:**
  - Patterns discovered
  - Gotchas encountered
  - Useful context

---
```

**Rules:**

- Never replace content—always append
- Include thread URL for future `read_thread` reference
- Move repeated learnings up to Codebase Patterns section
- Log verification failures with iteration number: `[iter 2] TypeError: ...`
