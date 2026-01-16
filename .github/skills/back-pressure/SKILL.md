---
name: back-pressure
description: Enforce test/type/lint gates before commits
---

# back-pressure

**Before any commit, run quality gates for your stack:**

| Stack       | Build           | Test          | Lint                                |
| ----------- | --------------- | ------------- | ----------------------------------- |
| .NET/Blazor | `dotnet build`  | `dotnet test` | `dotnet format --verify-no-changes` |
| Node.js     | `npm run build` | `npm test`    | `npm run lint`                      |
| Python      | —               | `pytest`      | `ruff check .` or `flake8`          |
| Rust        | `cargo build`   | `cargo test`  | `cargo clippy`                      |

**Type checking:**

- .NET: `dotnet build` (type errors are build errors)
- TypeScript: `tsc --noEmit`
- Python: `pyright` or `mypy`

**Frontend verification:**

- Use `dev-browser` skill to verify UI changes

**On failure:**

1. Fix the issue and retry
2. Maximum 3 attempts per issue
3. If still failing after 3 attempts → invoke `circuit-breaker` skill
4. Log all failures to progress.txt with iteration number

**Escalation:** If circuit-breaker triggers, abandon the current approach and note the blocker in AGENTS.md.
