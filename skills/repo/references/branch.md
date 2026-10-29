# Branch

Create one concise ASCII branch from the freshest available `main`. A remote is optional.

## Stop Before Creating

- No issue number or topic was provided, the worktree is clean, and no reasonable topic can be inferred after inspection.
- Branch creation fails for a reason other than an existing local or remote branch name.

## Steps

1. If `$ARGUMENTS` is a number, fetch the issue title with `gh api graphql` and derive the slug from that title. Use `gh issue view <number>` only as a narrow fallback.
2. If `$ARGUMENTS` is non-empty and not a number, derive the slug from that topic.
3. If no topic is provided, inspect `git status --short` and `git diff --stat`, then infer the slug from the changed area.
4. Generate a lowercase ASCII slug, hyphen-separated, 2-4 words.
5. Select the branch base without requiring `origin`:
   - Prefer the local `main` branch's configured upstream. Fetch its remote branch when available, then use the upstream ref.
   - Otherwise, fetch and use `origin/main` when `origin` is configured.
   - Otherwise, use local `main` when it exists.
   - Otherwise, use the current `HEAD` and report that fallback.
   - If a fetch fails but a local `main` or remote-tracking `main` ref exists, continue from that ref and report that it may be stale.
6. First try `git switch -c <name> <base>` without checking existing branches.
7. If creation fails due to an existing name, inspect only that name:
   - `git branch --list <name>`
   - Check the selected remote with `git ls-remote --heads <remote> <name>` only when a remote is available.
8. Retry with the next concise suffix, such as `-2` or `-3`.

## Rules

- Run `git fetch`, `git switch`, `git branch`, and `git ls-remote` as separate command invocations. Do not chain them with `&&`, `||`, `;`, or pipes.
- Do not stop only because `origin` or every remote is absent.
- Do not pre-check branch existence before the first create attempt.
- Do not request confirmation before branch creation when the topic is known or inferable.
- Stop with one concrete missing topic only when no issue/topic is provided and the worktree is clean.
- Keep branch names short and ASCII-only.
