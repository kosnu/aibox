# Grounding

Ground the task before planning edits.

## Entry Checks

- If `$ARGUMENTS` is an issue number, inspect it with `gh issue view <number>`.
- Read repository instructions such as `AGENTS.md` or `CLAUDE.md` when present.
- Treat files named in the issue or prompt as entry points, not guaranteed full scope.
- Identify affected areas, likely verification steps, integration boundaries, and local patterns.

## Model The Changed Behavior

Identify where the changed behavior or product rule is represented. Prefer a small set of categories:

- UI or UX behavior
- schema, types, or domain model
- mapping, API conversion, or orchestration
- state management or validation
- tests, stories, fixtures, or mocks
- performance, accessibility, rollout, or compatibility concerns

Record representations intentionally left unchanged and why.

## Contradiction Search

Before finishing the plan, look for evidence that contradicts the current understanding:

- old behavior still visible somewhere
- old assumptions encoded in tests, types, mapping, copy, or UI
- sibling components or flows that imply the previous rule
- repository conventions that conflict with the first implementation idea

Stop expanding search when the likely representation categories have been checked, or another targeted search pass reveals no new adjacent representation or contradiction.

## Missing Input

Stop planning and request only the missing input when:

- intended behavior or acceptance criteria cannot be inferred from the issue, repository, or conversation
- multiple implementation directions have different user-visible behavior, risk, or cost
- likely write scope expands materially beyond the user's stated task
