# Issue

Create one focused GitHub issue.

## Stop Before Creating

- The user has not approved the exact title and body.
- Multiple issue templates are equally plausible after inspection.
- Required content would need invented scope, acceptance criteria, or implementation details.
- Project selection is required but multiple plausible projects exist.

## Steps

1. Inspect `.github/ISSUE_TEMPLATE/` when it exists.
2. If templates exist, read likely templates and choose the best match from the request.
3. Use `gh api graphql` for project discovery when project metadata affects issue placement. Use `gh project list --limit 20` only for a simple project count/name check.
4. Auto-select a project only when exactly one project exists.
5. Draft a concise title and body from the user's request and selected template.
6. Remove template frontmatter and omit empty placeholder sections.
7. Show the exact title and body with this approval line: `この内容で作成する。承認する場合は「作成」と返す。`
8. Run `gh issue create --title "..." --body "..."` only after the user replies with explicit approval such as `作成`.
9. Include `--project` only when the project is known and unambiguous.

## Rules

- Keep the issue focused on the requested outcome.
- Do not add implementation choices the user did not approve.
- Choose the issue template and project yourself when there is one best match.
- Stop with one concrete missing input when templates or projects remain equally plausible.
- Prefer concise issue titles and bodies over template completeness.
- Show the created issue URL.
