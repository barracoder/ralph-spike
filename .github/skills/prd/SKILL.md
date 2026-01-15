---
name: prd
description: Generate/refine/validate structured PRDs → JSON tasks
---

# prd

**Location:** `scripts/ralph/prd.json`

**Format:** Object with `branchName` and `stories` array:
```json
{
  "branchName": "ralph/feature-name",
  "projectName": "My Project",
  "stories": [
    {
      "id": 1,
      "category": "setup|core|ui|feature|polish",
      "title": "Short title",
      "description": "What to build",
      "acceptance_criteria": ["Criterion 1"],
      "verification_steps": ["dotnet test"],
      "passes": false
    }
  ]
}
```

**Rules:**
- `branchName` required — ralph.sh uses it for branch tracking/archiving
- Small tasks: 1-3 files changed max
- Frontend → include "verify with dev-browser"
- Backend → include test + smoke test
- Never set `passes: true` — only verification loop does that
