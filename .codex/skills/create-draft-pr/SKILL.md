---
name: create-draft-pr
description: Creates a Draft Pull Request using repository PR template. Use when the user asks to create a PR, draft PR, or says "PRを作って".
argument-hint: "[issue-number]"
---

# Create Draft PR

## Steps

1. Understand full scope across all commits on branch:
   - `git log main..HEAD --oneline`
   - `git diff main..HEAD --stat`
   - Identify base branch, head branch, and related issue
2. Run `git status` to check uncommitted or out-of-scope changes
3. If PR template exists (for example `.github/PULL_REQUEST_TEMPLATE.md`), read and use it for PR body. Otherwise write clear body:
   - Keep the body concise
   - Keep only the minimum headings needed for reviewers
   - Prefer 2-3 short sections at most
   - Summarize each section in 1-3 short bullet points or 1 short paragraph
   - Link the related issue explicitly when available
   - If the branch fully satisfies the issue's completion conditions, use `- closes #{issue-number}`
   - If the branch is still related to the issue but does not fully satisfy its completion conditions, use `- #{issue-number}`
   - Describe changes from actual diff
   - Check only verified items
   - Add notes only when they are necessary for review
4. Push current branch before PR creation:
   - `git branch --show-current`
   - `git push -u origin <branch>` when needed
5. Create Draft PR with `gh pr create --draft` without extra approval
6. Delete any temporary PR body file created during the process
   - If the temporary file is under `.codex/` or another path known to require elevated permissions for deletion, delete it with escalation first instead of attempting a non-escalated removal
7. Verify title, body, branch, and issue link after creation

## Rules

- Default to Draft. Mark Ready for Review only on explicit request.
- Always push head branch before `gh pr create`.
- Decide whether to use `closes` by checking the actual issue completion conditions against the current branch diff, not just by matching branch name or intent.
- Do not keep template headings that add no review value.
- No empty fields or placeholder text.
- Prefer short PR titles and bodies. Avoid repetitive explanation.
- In the final user-facing report, keep it brief and do not enumerate file names unless the user asks.
- Temporary files created only for PR creation must be removed before finishing the task.
- When deleting temporary files under `.codex/`, prefer an escalated `rm` immediately because sandboxed deletion may fail with `Operation not permitted`.
