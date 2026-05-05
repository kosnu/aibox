---
name: git-branch
description: Creates a feature branch from a GitHub issue number or a short branch topic. Use when the user asks to create a branch, start working on an issue, or says "ブランチを切って".
argument-hint: "[issue-number|branch-topic]"
---

# Create Branch

## Success Criteria

A successful run creates and switches to one concise ASCII branch from the latest `main`, using an issue-derived or topic-derived slug.

The final report should name the branch and mention the source base.

## Stop Rules

Stop before creating a branch when:

- no issue number or topic was provided and the clean worktree gives no reasonable topic to infer
- `origin/main` cannot be fetched
- the proposed branch name already exists locally or remotely and choosing a different name would require user intent

## Steps

1. Determine whether `$ARGUMENTS` is a GitHub Issue number:
   - If it is a number, run `gh issue view $ARGUMENTS` to get the issue title and content.
   - If it is non-empty and not a number, treat `$ARGUMENTS` as a short branch topic and do not call `gh issue view`.
   - If it is empty, inspect the current worktree with `git status --short` and `git diff --stat` to infer a branch topic from the changed files and directories.
2. Generate a short English slug (lowercase, hyphen-separated, 2-4 words):
   - With an Issue number, generate the slug from the Issue title.
   - Without an Issue number, generate the slug from the provided branch topic.
   - If no topic was provided, infer the slug from the current diff. Prefer the dominant changed area or intent, such as `update-git-branch-skill`, `fix-login-form`, or `add-user-api`.
3. Create the branch from latest `main` without asking for confirmation:
   - With an Issue number:
     ```bash
     git fetch origin main
     git switch -c issue-{number}/{slug} origin/main
     ```
   - Without an Issue number:
     ```bash
     git fetch origin main
     git switch -c codex/{slug} origin/main
     ```

## Next Action

Suggest `$task $ARGUMENTS` after branch creation when the branch is tied to a task or issue.

## Rules

- If the user did not provide any branch topic and there is no Issue number, inspect the current diff first and infer a reasonable topic yourself.
- Only ask the user for a branch topic when there is no Issue number and the worktree is clean, so no reasonable topic can be inferred.
- Keep branch names ASCII-only and concise.
- Prefer `issue-{number}/{slug}` for Issue-driven work and `codex/{slug}` for ad hoc work.
- Do not create multiple branch candidates; choose the single best branch name from the available issue, topic, or diff evidence.
