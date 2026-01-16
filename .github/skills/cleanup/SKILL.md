---
name: cleanup
description: Clean temp files/branches after loop
---

# cleanup

After loop completes:

1. Delete merged feature branches: `git branch -d ralph-*`
2. Remove temp files: `rm -rf .ralph/ ralph-*.log progress.txt.bak`
3. If task failed, leave branch for manual review
