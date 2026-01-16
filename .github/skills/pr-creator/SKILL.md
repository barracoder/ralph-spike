---
name: pr-creator
description: Create pull requests with summary from Ralph progress
---

# pr-creator

Create a pull request after Ralph completes all stories.

## When to Use

Invoke this skill after outputting `<promise>COMPLETE</promise>` to create a PR summarizing the work.

## PR Creation

**Using GitHub CLI:**
```bash
# Ensure you're on the feature branch
BRANCH=$(git branch --show-current)

# Push if not already pushed
git push -u origin "$BRANCH" 2>/dev/null || git push

# Create PR
gh pr create \
  --title "feat: [Project Name] - Ralph automated implementation" \
  --body-file /dev/stdin <<EOF
## Summary

Automated implementation by Ralph agent.

## Stories Completed

$(jq -r '.stories[] | select(.passes == true) | "- [x] \(.id): \(.title)"' scripts/ralph/prd.json)

## Stories Blocked (if any)

$(jq -r '.stories[] | select(.blocked == true) | "- [ ] \(.id): \(.title) — \(.blockReason)"' scripts/ralph/prd.json)

## Codebase Patterns Discovered

$(head -50 scripts/ralph/progress.txt | grep -A 100 "## Codebase Patterns" | grep "^-" | head -10)

## Verification

- [ ] All automated tests pass
- [ ] Manual review of key changes
- [ ] Browser verification of UI changes

---
*Generated from \`scripts/ralph/progress.txt\`*
EOF
```

## PR Content Structure

The PR body should include:

1. **Summary** — Brief description of what was built
2. **Stories Completed** — Checklist from prd.json where `passes: true`
3. **Stories Blocked** — Any stories that triggered circuit-breaker
4. **Codebase Patterns** — Key learnings from progress.txt
5. **Verification checklist** — For reviewer to confirm

## Alternative: Manual PR Body

If `gh` CLI is unavailable, output this for the user:

```markdown
## PR Template

**Title:** `feat: [Project Name] - Ralph automated implementation`

**Body:**

[Paste summary from progress.txt Codebase Patterns section]

**Stories completed:**
- List each story with `passes: true`

**Files changed:**
- Key files modified across all stories

**Testing:**
- How to verify the implementation works
```

## Post-PR Actions

After PR is created:

1. Link the PR URL in progress.txt as final entry
2. Run `cleanup` skill to remove temp files (if configured)
3. Notify user that review is ready

## Integration with Ralph Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  Ralph Loop                                                      │
│                                                                  │
│  stories with passes:false → implement → commit                  │
│                    ↓                                             │
│  all passes:true → <promise>COMPLETE</promise>                   │
│                    ↓                                             │
│  pr-creator skill → gh pr create                                 │
│                    ↓                                             │
│  cleanup skill → remove temp files                               │
└─────────────────────────────────────────────────────────────────┘
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `gh` not authenticated | Run `gh auth login` |
| No upstream branch | Script includes `git push -u origin` |
| jq not installed | Use manual PR template |
| Branch protection | PR will be created but may need approval |
