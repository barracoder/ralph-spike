---
name: progress-logger
description: Maintain progress.txt with failures & patterns
---

# progress-logger

Maintain `progress.txt` with:

```
## Current Task
id: 3, title: Add auth

## Verification Failures
- [iter 2] TypeError: cannot read undefined — fixed by null check

## Patterns Noticed
- API returns 401 when token expired, need refresh logic
```

Update after each iteration. Helps diagnose stalls.
