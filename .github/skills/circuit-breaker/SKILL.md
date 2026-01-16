---
name: circuit-breaker
description: Detect stalled loops, log context, and halt gracefully
---

# circuit-breaker

## Trigger Conditions

Activate circuit breaker if ANY of these occur:

- 4+ iterations with no meaningful file changes
- Same error repeating 3+ times without resolution
- Build/test failures persisting after 3 fix attempts (from `back-pressure`)

## When Triggered

**1. Output the halt signal:**
```
<circuit_open>REPEATED_FAILURE</circuit_open>
```

**2. Log to progress.txt:**
```markdown
## [Date/Time] - CIRCUIT BREAKER TRIGGERED
Story: [Story ID] - [Story Title]
Reason: [Brief description of the failure pattern]
Last error: [The repeating error message]
Attempts: [Number of iterations attempted]
Files affected: [List of files being modified]
---
```

**3. Update prd.json:**
Add `"blocked": true` and `"blockReason": "..."` to the story:
```json
{
  "id": 5,
  "passes": false,
  "blocked": true,
  "blockReason": "TypeScript error in auth.ts line 42 - requires manual investigation"
}
```

**4. Stop immediately** — do not attempt further fixes

## Recovery (Manual)

When a human investigates:
1. Review the progress.txt entry for context
2. Check the thread URL from previous iterations
3. Fix the underlying issue
4. Remove `blocked` and `blockReason` from prd.json
5. Resume Ralph loop
