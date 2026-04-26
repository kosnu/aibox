---
name: git-commit
description: Stages and commits changes with Japanese commit messages. Use when the user asks to commit, stage changes, or says "コミットして".
---

# Commit Changes

## Steps

1. Inspect unstaged changes with fixed lightweight commands:
   - Run `git status --short` to inspect changed paths
   - Run `git diff --name-status` to inspect change types
   - Run `git diff --unified=0 --no-ext-diff -- <path>` only for specific non-generated files that need content review
   - Skip content diffs for generated files, lockfiles, or vendored files unless the user explicitly asks
2. Run project-specific verification defined in `CLAUDE.md` or `AGENTS.md` when available. Do not commit on failure.
3. Stage files individually (`git add -A` only when all changes are intentionally in scope)
4. Split commits by concern (feature, bugfix, refactor)
5. Inspect staged changes with fixed lightweight commands:
   - Run `git diff --staged --name-status` to confirm staged scope
   - Run `git diff --staged --unified=0 --no-ext-diff -- <path>` only for specific staged non-generated files that need content review
   - Skip staged content diffs for generated files, lockfiles, or vendored files unless the user explicitly asks
6. Commit without asking for extra approval
7. Show result with `git log -1 --pretty=format:"%h: %s"`

## Commit Message Format

```text
{type}: {message in Japanese}

{description in Japanese}

Co-Authored-By: Codex <codex@openai.com>
```

Types: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`

## Rules

- Do not include unrelated changes.
- Do not read full diffs for generated files, lockfiles, or vendored files unless the user explicitly asks.
- When running `git commit`, pass the subject/body/trailer with separate `-m` flags instead of embedding literal `\n` in one shell string.

## Next Action

Suggest `$create-draft-pr` after commit if appropriate.
