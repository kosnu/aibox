# Branch

Create one concise ASCII branch from latest `main`.

## Stop Before Creating

- No issue number or topic was provided, the worktree is clean, and no reasonable topic can be inferred after inspection.
- `origin/main` cannot be fetched.
- Branch creation fails for a reason other than an existing local or remote branch name.

## Steps

1. If `$ARGUMENTS` is a number, run `gh issue view <number>` and derive the slug from the issue title.
2. If `$ARGUMENTS` is non-empty and not a number, derive the slug from that topic.
3. If no topic is provided, inspect `git status --short` and `git diff --stat`, then infer the slug from the changed area.
4. Generate a lowercase ASCII slug, hyphen-separated, 2-4 words.
5. Run `git fetch origin main`.
6. First try branch creation without checking existing branches:
   - issue-driven: `git switch -c issue-<number>/<slug> origin/main`
   - ad hoc: `git switch -c codex/<slug> origin/main`
7. If creation fails due to an existing name, inspect only that name:
   - `git branch --list <name>`
   - `git ls-remote --heads origin <name>`
8. Retry with the next concise suffix, such as `-2` or `-3`.

## Rules

- Do not pre-check branch existence before the first create attempt.
- Do not request confirmation before branch creation when the topic is known or inferable.
- Stop with one concrete missing topic only when no issue/topic is provided and the worktree is clean.
- Keep branch names short and ASCII-only.
