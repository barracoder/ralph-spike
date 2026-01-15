---
name: prd
description: Generate/refine/validate structured PRDs → JSON tasks
---

# prd

**Output format:** `prd.json`

```json
[
  {
    "id": 1,
    "category": "core",
    "title": "Short title",
    "description": "What to build",
    "acceptance_criteria": ["Criterion 1"],
    "verification_steps": ["npm test"],
    "passes": false
  }
]
```

**Rules:**

- Small tasks: 1-3 files changed max
- Frontend → include "verify with dev-browser"
- Backend → include test + smoke test
- Never set `passes: true` — only verification loop does that
