---
name: multi-perspective-review
description: Review an artifact when the user explicitly requests multi-perspective review, names this skill, or names multiple specialist viewpoints. Not for generic review requests.
---

# Multi Perspective Review

Review the user-specified target with the smallest set of expert perspectives that covers its risks. The target may be in GitHub, Git, or a local file.

The main agent owns final judgment, integration of feedback, and the report. Subagents provide independent checks only when they materially reduce risk; their model and assignment constraints are defined in [reviewer-contract.md](references/reviewer-contract.md).

Do not edit files during the review unless the user also asked to fix findings. If the user only asked for review, report findings and stop.

## Review Basis

Inspect the request or approved plan, the target, and evidence needed to check its claims. For repository targets, account for unrelated dirty and untracked files. Use relevant tests, fixtures, schemas, configuration, docs, and existing verification as evidence; do not read unrelated areas just to complete a checklist.

For a PR target or a branch with a PR, read [github-context.md](references/github-context.md) for PR comments and applicable Issue requirements. A standalone artifact does not require unrelated GitHub context.

## Review and Completion

- Use [reviewer-budget.md](references/reviewer-budget.md) to classify risk and choose the smallest useful budget, and [perspectives.md](references/perspectives.md) to select relevant viewpoints.
- Apply the main-agent checklist in [reviewer-contract.md](references/reviewer-contract.md). Read its assignment details when delegating independent concerns; preserve the low-cost model and self-contained context requirements.
- Verify and deduplicate findings against the target. If fixes were requested, complete in-scope fixes and relevant verification; obtain approval before changes outside the authorized scope or behavior.
- Report findings and verification gaps using [report-format.md](references/report-format.md). Completion is a supported judgment of the requested target, including a clear statement when no actionable findings remain.
