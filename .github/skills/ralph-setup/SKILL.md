---
name: ralph-setup
description: Initialize or repair Ralph loop structure
---

# ralph-setup

**Required structure:**

```
scripts/ralph/ralph.sh   # loop runner
scripts/ralph/prompt.md  # system prompt
prd.json                 # task list
progress.txt             # iteration log
AGENTS.md                # persistent learnings
```

**Setup:**

1. Fetch ralph.sh from `snarktank/ralph` or `iannuttall/ralph`
2. Create skeleton prd.json
3. Add `.ralph/` to .gitignore
4. Branch: `git checkout -b ralph-[slug]`

**Output when done:** "Ralph ready — load prd skill to begin."
