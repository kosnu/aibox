# Pull Request

Create an open pull request by default.

## Stop Before Creating

- The current branch cannot be identified.
- The branch diff contains unrelated or unexplained changes.
- A related issue cannot be linked correctly and the PR body would be misleading.
- Required template content cannot be completed without inventing unverified information.

## Steps

1. Inspect branch scope:
   - `git log main..HEAD --oneline`
   - `git diff main..HEAD --stat`
2. Run `git status` and account for uncommitted or out-of-scope changes.
3. Use `gh api graphql` to fetch existing PR state, issue metadata, linked issue context, and base/head details when those facts affect title, body, or close-link decisions.
4. Read `.github/PULL_REQUEST_TEMPLATE.md` when it exists.
5. Write a concise PR title and body from the actual diff.
6. Link related issues only when verified; omit unverified issue links.
7. Use `closes #<number>` only when the branch satisfies the issue.
8. Push the current branch before PR creation.
9. Run `gh pr create` without `--draft`.
10. Delete any temporary PR body file created during the process.
11. Verify title, body, base branch, head branch, and issue link after creation. Prefer `gh api graphql` for this verification when checking multiple PR fields.

## Rules

- Run `git`, `gh api`, `gh pr create`, and cleanup commands as separate command invocations. Do not chain them with `&&`, `||`, `;`, or pipes.
- Default to open PR. Use draft only when the user explicitly requests it.
- Keep the body short and useful for review.
- Do not keep empty template headings or placeholder text.
- Base the PR on actual commits and diff, not just the branch name.
- Prefer GraphQL for PR reads that combine status, issue links, review state, or branch metadata.
- Do not request extra confirmation before creating the PR when scope is clear.
- In PR comments, do not wrap commit IDs in backticks.
