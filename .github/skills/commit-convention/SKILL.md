---
name: commit-convention
description: Use conventional commits aligned with Ralph workflow
---

# commit-convention

**Format:** `type: [Story ID] - [Story Title]`

**Types:** `feat` | `fix` | `refactor` | `test` | `chore` | `docs` | `wip`

**Examples:**

```
feat: [5] - Add OAuth2 login

- Verification: tests pass, browser ok
```

```
wip: [5] - Add OAuth2 login (partial)

- Auth flow implemented, token refresh pending
```

**Rules:**

- Always on feature branch (from prd.json `branchName`), never main
- Use `wip:` prefix for partial/incomplete work
- Push if remote exists
- Reference prd.json story ID in square brackets
