---
name: prd
description: Generate/refine/validate structured PRDs → JSON tasks
---

# prd

**Location:** `scripts/ralph/prd.json`

**Source:** Derived from human-readable `scripts/PRD.md`

## Schema

```json
{
  "branchName": "ralph/feature-name",
  "projectName": "My Project",
  "stories": [
    {
      "id": 1,
      "priority": 1,
      "dependsOn": [],
      "category": "setup|core|ui|feature|polish",
      "title": "Short title",
      "description": "What to build",
      "acceptance_criteria": ["Criterion 1", "Criterion 2"],
      "verification_steps": ["dotnet test", "verify with dev-browser"],
      "passes": false
    }
  ]
}
```

## Field Reference

| Field         | Required    | Description                                           |
| ------------- | ----------- | ----------------------------------------------------- |
| `branchName`  | **Yes**     | Git branch name; ralph.sh uses for tracking/archiving |
| `stories`     | **Yes**     | Array of user stories                                 |
| `id`          | **Yes**     | Unique integer identifier                             |
| `priority`    | Recommended | Lower number = higher priority (1 is highest)         |
| `dependsOn`   | Recommended | Array of story IDs that must complete first           |
| `category`    | Recommended | Grouping: setup, core, ui, feature, polish            |
| `passes`      | **Yes**     | Boolean; only set `true` after verification passes    |
| `blocked`     | Optional    | Set by circuit-breaker when story cannot proceed      |
| `blockReason` | Optional    | Explanation of why story is blocked                   |

## Story Selection Rules

When picking the next story to implement:

1. **Filter:** Exclude stories where `passes: true` or `blocked: true`
2. **Dependencies:** Exclude stories whose `dependsOn` contains incomplete story IDs
3. **Priority:** Sort remaining by `priority` (ascending—lower is higher priority)
4. **Tiebreaker:** If priorities equal, use `id` order

## Sizing Rules

- Small tasks: 1-3 files changed max
- Frontend stories → include "verify with dev-browser" in verification_steps
- Backend stories → include test command in verification_steps
- Never set `passes: true` manually—only the verification loop does that
