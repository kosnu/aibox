---
name: workstart
description: Start a git worktree workspace from an issue number or branch name.
---

Use this skill when the user asks to start work in a new workspace.

## Behavior
- If the argument is an issue number, derive the branch from issue title.
- If the argument is not numeric, treat it as a branch name.
- Create or attach worktree and open a workspace tab.

## Implementation

Run:

```bash
.github/skills/worktree-workspace/scripts/worktree_tab.sh workstart <issue-number-or-branch-name>
```
