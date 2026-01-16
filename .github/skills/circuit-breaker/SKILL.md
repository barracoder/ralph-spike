---
name: circuit-breaker
description: Detect stalled loops & halt
---

# circuit-breaker

If 4+ iterations with no file changes or same error:

```
<circuit_open>REPEATED_FAILURE</circuit_open>
```

Then **stop immediately**.
