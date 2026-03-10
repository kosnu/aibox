---
name: workstop
description: Stop a git worktree workspace for a branch name.
---

Use this skill when the user asks to stop and clean up a workspace.

## Behavior
- Close the tab for the branch (if available).
- Remove the corresponding worktree.

## Implementation

Run:

```bash
.github/skills/worktree-workspace/scripts/worktree_tab.sh workstop <branch-name>
```
