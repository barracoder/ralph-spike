---
name: code-review
description: Self-review changes for quality/security/readability
---

# code-review

Before commit, check:

- [ ] DRY — no duplicated logic
- [ ] Single responsibility
- [ ] Error handling present
- [ ] No secrets/credentials in code
- [ ] No injection vulnerabilities
- [ ] Clear naming
- [ ] Comments where non-obvious

Fix issues inline. Run `git diff --staged` to review.
