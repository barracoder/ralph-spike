---
name: commit-convention
description: Use conventional commits with scope & verification
---

# commit-convention

**Format:** `type(scope): description [task-id]`

**Types:** `feat` | `fix` | `refactor` | `test` | `chore` | `docs`

**Example:**

```
feat(auth): add OAuth2 login [task-5]

- Verification: tests pass, browser ok
- PRD item: #5
```

**Rules:**

- Always on feature branch, never main
- Push if remote exists
