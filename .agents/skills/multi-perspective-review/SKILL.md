---
name: multi-perspective-review
description: Review an already implemented repository diff from budgeted expert perspectives after code changes are complete. Use when Codex needs post-implementation review before final verification, commit, PR, or handoff, especially when the user asks for senior engineer, senior architect, QA, performance, security, accessibility, migration, or multi-perspective review of a diff.
---

# Multi Perspective Review

Review an implemented diff with the smallest set of expert perspectives that still covers the real risk. Use this skill after changes exist, not for planning or design approval before implementation.

The main agent owns final judgment, integration of reviewer feedback, and the user-facing report. Subagents provide independent review passes only when their perspective can materially reduce risk.

## Entry Gate

Use this skill only when there is an implemented change to review.

Before assigning reviewers, the main agent must inspect:

- the user request or approved plan that explains the intended behavior
- the current diff and touched files
- the current branch's PR summary and review comments when a PR exists
- the linked or referenced issue when it materially defines intent, scope, acceptance criteria, or reviewer context
- relevant tests, stories, fixtures, schemas, configs, or docs changed by the diff
- verification already run, if any
- dirty worktree state that may be unrelated to the review target

Read [references/github-context.md](references/github-context.md) whenever the current branch has a PR or the user identifies a PR. It defines the required GitHub context, Issue inclusion rules, and efficient retrieval policy.

Do not edit files during the review unless the user also asked to fix findings. If the user only asked for review, report findings and stop.

## Workflow

1. Inspect the implemented diff and required local context from the entry gate.
2. Collect applicable GitHub context from `github-context.md`.
3. Read [references/reviewer-budget.md](references/reviewer-budget.md), classify risk, and choose the smallest useful reviewer budget.
4. Read [references/perspectives.md](references/perspectives.md) and assign only perspectives that match the diff.
5. Read [references/reviewer-contract.md](references/reviewer-contract.md), perform the main-agent checklist, and delegate only independent review concerns.
6. Merge and verify findings. Stop for approval before fixing any material scope or behavior change.
7. Read [references/report-format.md](references/report-format.md) and report findings first.
