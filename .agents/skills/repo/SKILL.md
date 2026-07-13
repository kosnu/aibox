---
name: repo
description: Unified repository workflow entrypoint for creating GitHub issues, creating branches, committing changes, creating open pull requests, and shipping work end to end. Use when the user requests repo work such as "issue作って", "ブランチを切って", "コミットして", "PRを作って", "shipして", or invokes "$repo issue|branch|commit|pr|ship".
---

# Repo Workflow

Use this skill as the primary repository workflow for issue creation, branch creation, commits, open pull requests, and end-to-end shipping.

## Mode Selection

- `issue`: Draft and create a GitHub issue. Read `references/issue.md`.
- `branch`: Create and switch to a branch from latest `main`. Read `references/branch.md`.
- `commit`: Stage and commit scoped changes. Read `references/commit.md`.
- `pr`: Push the branch and create an open pull request. Read `references/pr.md`.
- `ship`: Run only the needed modes in order: `issue`, `branch`, `commit`, `pr`.

Infer the mode from `$ARGUMENTS` and the user's wording. If the requested mode is ambiguous, inspect the repository state first and choose the smallest safe workflow.

For `ship`, read only the reference files needed for the missing steps. Do not create duplicate issues, branches, commits, or PRs when the current repository state already satisfies a step.

## Command Execution

Run each `git`, `gh`, and shell command as a separate command invocation.

- Do not join commands with shell control operators such as `&&`, `||`, `;`, or `|`.
- Do not use subshells or command substitution to combine dependent commands.
- Let each command finish, inspect the result, then run the next command.
- Keep commands in a form that matches narrow approval rules such as `git fetch origin main`, `git switch`, `git add`, `git commit -m`, `git push`, `gh api`, `gh issue create`, and `gh pr create`.
- For `ship`, execute the selected modes step by step; never collapse branch, commit, push, and PR creation into one shell line.

## Decision Style

Prefer deciding and executing over asking.

- Inspect local and GitHub state before requesting input.
- Choose the smallest safe workflow that matches the user's command.
- Do not request confirmation when the requested side effect is already clear.
- When a side effect requires explicit approval, present the exact artifact and the exact approval phrase.
- If required information is still missing after inspection, stop with one concrete missing input instead of asking an open-ended question.

## Pull Request Default

Create open PRs by default. Use draft PRs only when the user explicitly requests draft.

## GitHub Data Access

Prefer `gh api graphql` for GitHub reads that need multiple fields, relationship checks, or precise state in one call.

- Use GraphQL for issue/PR metadata, linked issues, project fields, review status, merge state, and branch/head/base details when those facts affect decisions.
- Use narrow `gh issue view`, `gh pr view`, or `gh project list` only for simple one-object reads where GraphQL would add no value.
- Keep write operations on explicit commands such as `gh issue create` and `gh pr create` unless GraphQL is required for a capability not available through `gh` subcommands.

## Subagents

Do not use subagents by default.

Use a lower-cost subagent only for a bounded read-only reduction stage when a large diff, CI history, or review history can be reduced enough to replace equivalent main-agent reading. Routine diff inspection, commit splitting, PR title/body judgment, issue close decisions, and all git or GitHub side effects stay with the main agent.

Give the subagent one question, explicit input and ownership boundaries, and this compact result shape:

```text
question
findings[]
evidence[{path_or_url, line_or_id, reason}]
unresolved[]
stop_reason
```

Allow at most one retry for missing required evidence. The main agent verifies material evidence, does not repeat completed retrieval, and owns every final decision and write.
