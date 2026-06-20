# Commit

Create narrowly scoped commits with Japanese messages.

## Stop Before Committing

- There are no in-scope changes.
- Changed files include unrelated work that cannot be separated safely.
- Required verification from `AGENTS.md` fails.
- The intended commit split is risky enough that staging would mix unrelated concerns.

## Steps

1. Inspect `git status --short`.
2. Inspect `git diff --name-status`.
3. Review content diffs only for specific non-generated files that need it.
4. Run required verification from `AGENTS.md` when applicable.
5. Stage only files that belong to the current commit concern.
6. Decide the commit split yourself when the diff contains independent changes.
7. Verify staged scope with `git diff --staged --name-status`.
8. Commit with separate `-m` flags for subject, body, and trailer.
9. Show `git log -1 --pretty=format:"%h: %s"`.

## Message Format

```text
{type}: {message in Japanese}

{description in Japanese}

Co-Authored-By: Codex <codex@openai.com>
```

Types: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`.

## Rules

- Do not include unrelated changes.
- Do not read full diffs for generated files, lockfiles, or vendored files unless the user explicitly requests it.
- Do not request extra confirmation before committing when the scope is clear.
- If the split is unsafe, stop and present the concrete recommended split.
- Use Japanese commit messages.
