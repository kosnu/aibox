---
name: task-plan
description: Investigate a repository task, model the changed behavior, apply size/risk-based subagent budgets for investigation and review, and produce an approval-ready implementation plan. Use when the user says "$task-plan" or asks to plan work before editing.
---

# Task Planning Workflow

Produce an approval-ready implementation plan before any edits.

State the changed behavior or product rule in one sentence, identify the representations that must stay in sync, review the plan, and stop after presenting the plan for user approval.

## Entry Gate

Use this skill only when the user wants a plan before implementation, explicitly invokes `$task-plan`, or asks for planning work.

If the user asks only for an explanation, investigation, feasibility assessment, comparison, or recommendation, answer that request directly. Do not escalate into an approval-ready implementation plan unless they ask for one.

## Workflow

1. Ground the task and preserve uncertainty. Read `references/01-grounding.md`.
2. Classify size by synchronized representation concerns. Read `references/02-size-and-scope.md`.
3. Choose the smallest useful subagent budget. Read `references/03-subagent-budgets.md`.
4. Build the approval-ready plan. Read `references/04-plan-format.md`.
5. Review the plan before presenting it. Read `references/05-review-rubric.md`.
6. Present the plan and stop before edits. Read `references/06-approval-gate.md`.

## Size Summary

- **Small:** 1 primary concern, even when reflected mechanically across files.
- **Medium:** 2-3 concerns, or one behavior change where synchronization can drift.
- **Large:** 4 or more concerns, cross-system contract changes, high-risk domains, migrations, or irreversible data changes.

Do not classify by raw file count alone.

## Subagent Summary

- **Small:** use no subagent by default; use 1 cheap explorer only for a named independent uncertainty.
- **Medium:** consider 1 cheap explorer or reviewer; skip it when main-agent grounding covers the risk.
- **Large:** use multiple subagents only when each has an independent question and ownership boundary.

The main agent owns repository instructions, critical-path grounding, contradiction search, final judgment, and the final plan.

## Non-Negotiable Rules

- Do not edit files during this skill.
- Do not skip repository grounding.
- Do not skip plan review before requesting approval.
- Do not skip user approval before implementation.
- Keep the plan compact, decision-complete, and scoped to the requested task.
