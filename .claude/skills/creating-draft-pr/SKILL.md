---
name: creating-draft-pr
description: Creates a Draft Pull Request using the repository's PR template. Use when the user asks to create a PR, draft PR, or says "PRを作って".
disable-model-invocation: true
model: sonnet
argument-hint: "[issue-number]"
---

# Create Draft PR

## Steps

1. Understand the full scope of changes across ALL commits on the branch (not just the latest one):
   - `git log main..HEAD --oneline` to list all commits
   - `git diff main..HEAD --stat` to see all changed files
   - Identify base branch, head branch, and related issue
2. Run `git status` to check for uncommitted or out-of-scope changes
3. If a PR template exists (e.g. `.github/PULL_REQUEST_TEMPLATE.md`), read it and use it to draft the PR body. Otherwise, write a clear PR description:
   - PR title and description must summarize ALL commits comprehensively
   - Link related issue number if available
   - Describe changes based on actual diffs
   - Only check off verified items (never mark unverified as done)
   - Add review points in notes section
4. Push the current branch to remote before creating the PR:
   - Check branch name: `git branch --show-current`
   - Push with upstream if needed: `git push -u origin <branch>`
5. Create with `gh pr create --draft` without asking for approval
6. Verify title, body, branch, and issue link after creation

## Rules

- Default to Draft (only mark Ready for Review when explicitly requested)
- Always push the head branch to remote before running `gh pr create`
- If using a template, keep all template headings intact
- No empty fields or placeholder text
