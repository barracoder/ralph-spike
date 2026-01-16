---
name: back-pressure
description: Enforce test/type/lint gates before commits
---

# back-pressure

**Before any commit:**

1. Run tests: `npm test` / `pytest` / `cargo test`
2. Type check: `tsc --noEmit` / `pyright` / `mypy`
3. Lint/format: fix or fail
4. Frontend? → use dev-browser skill

**On failure:** Fix and retry (max 3 attempts). If still failing → abandon branch, note in AGENTS.md.

Log all failures to progress.txt.
