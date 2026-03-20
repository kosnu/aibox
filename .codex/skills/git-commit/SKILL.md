---
name: git-commit
description: Stages and commits changes with Japanese commit messages. Use when the user asks to commit, stage changes, or says "コミットして".
---

# Commit Changes

## Steps

1. Run `git status` and `git diff --stat` to inspect current changes
2. Run project-specific verification defined in `CLAUDE.md` or `AGENTS.md` when available. Do not commit on failure.
   - Even if the user asked to run only part of the verification earlier in the conversation, rerun the full required verification immediately before committing unless the user explicitly instructs you to skip it at commit time
3. Stage files individually (`git add -A` only when all changes are intentionally in scope)
4. Split commits by concern (feature, bugfix, refactor)
5. Run `git diff --staged --stat` to confirm staged scope
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
- Treat commit-time verification as a fresh gate: only checks that you yourself ran successfully just before the commit count as verified.
- When running `git commit`, pass the subject/body/trailer with separate `-m` flags instead of embedding literal `\n` in one shell string.

## Next Action

Suggest `/create-draft-pr` after commit if appropriate.
