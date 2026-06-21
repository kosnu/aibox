---
name: task-execute
description: Execute an approved repository task plan, keep changed behavior synchronized, and use size/risk-based subagent budgets for implementation and review. Use when the user says "$task-execute" or asks to implement an approved plan.
argument-hint: "[approved plan or task description with explicit approval]"
---

# Task Execution Workflow

Implement an already approved plan, keep the changed behavior synchronized across its representations, review the diff within the approved size/risk budget, and finish with verification.

Treat execution as execution, not planning. Once an approved plan exists, do not drift back into planning mode during this skill.

## Entry Gate

Do not start implementation unless an approved plan already exists in the conversation or the user explicitly provides one.

If there is no approved plan, stop and tell the user to run `$task-plan` first or provide an approved plan directly.

If an approved plan exists, do not create a new plan. Restate only the approved behavior, size/risk, synchronized representations, immediate blockers, parallel work, and subagent budget needed to begin safely.

## Workflow

1. Prepare execution from the approved plan. Read `references/01-prepare-execution.md`.
2. Choose the smallest safe implementation budget. Read `references/02-execution-budget.md`.
3. Implement the approved scope and preserve synchronization. Read `references/03-implementation.md`.
4. Stop for re-approval when approved scope changes. Read `references/04-reapproval-gate.md`.
5. Review the implemented diff within budget. Read `references/05-review.md`.
6. Verify and report the result. Read `references/06-verify-and-report.md`.

## Subagent Summary

- **Small:** main agent implements; do not use worker subagents.
- **Medium:** use at most 1 worker only when ownership is clearly separated.
- **Large:** use multiple workers only when each has disjoint ownership and main-agent integration remains controlled.

Use reviewer subagents only after implementation, unless a narrow read-only explorer question immediately unblocks a safe edit.

## Non-Negotiable Rules

- Never implement without an approved plan.
- Never create a new approval-ready plan inside this skill.
- Never continue after a material plan change without re-approval.
- Never skip post-implementation review.
- Keep tool usage specific and efficient.
- Keep the final report concise.
