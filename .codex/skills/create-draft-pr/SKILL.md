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
   - Summarize all commits comprehensively
   - Link related issue if available
   - Describe changes from actual diff
   - Check only verified items
   - Add review points in notes section
4. Push current branch before PR creation:
   - `git branch --show-current`
   - `git push -u origin <branch>` when needed
5. Create Draft PR with `gh pr create --draft` without extra approval
6. Verify title, body, branch, and issue link after creation

## Rules

- Default to Draft. Mark Ready for Review only on explicit request.
- Always push head branch before `gh pr create`.
- Keep all template headings if a template is used.
- No empty fields or placeholder text.
