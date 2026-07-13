# Subagent Budgets

Use the smallest subagent budget that still protects repository rules, local patterns, and unstated conventions.

Subagents are optional helpers. They are useful for independent exploration, missing-representation checks, and review. They do not own final judgment.

## Main Agent Responsibilities

The main agent must cover:

- repository instructions
- named files, issue references, and explicit entry points
- nearby imports, sibling implementations, and local patterns
- relevant tests, stories, fixtures, mocks, and verification commands
- contradiction-search targets
- final plan synthesis and approval wording

## Investigation Budget

- **Small / Low risk:** main-agent investigation only by default. Use at most 1 cheap `explorer` only when a concrete independent risk is named.
- **Small / Normal risk:** main-agent investigation remains primary. Use at most 1 cheap `explorer` for a clearly independent uncertainty.
- **Medium:** use 1 cheap `explorer` when it can answer an independent question in parallel. Skip it when main-agent grounding already covers the risk.
- **Large / High risk:** multiple subagents are allowed when each has an explicit role, ownership boundary, and independent question.

If no subagent is used, record the main-agent checks that covered repository rules, local patterns, relevant tests, and contradiction targets.

## Review Budget

- **Small / Low risk:** main agent checklist review only; record it as local review.
- **Small / Normal risk:** at most 1 reviewer subagent focused on pattern drift, stale assumptions, or missing representations.
- **Medium:** 1 reviewer is usually enough when concerns are coupled; use 2 only for distinct risk areas.
- **Large / High risk:** 2 or more reviewers when UX, performance, data, rollout, or other risks need distinct ownership.

Prefer cheap explorer/reviewer models when the task is structural, read-only, or review-oriented. Use stronger models only when the subtask has high ambiguity, high risk, or requires deep code reasoning.

## Delegation Contract

Delegate one bounded question with explicit repository scope and stop condition. Require:

```text
question
findings[]
evidence[{path_or_url, line_or_id, reason}]
unresolved[]
stop_reason
```

Allow at most one retry when required evidence is missing. The main agent verifies material evidence, avoids repeating completed exploration, and owns synthesis, approval wording, and all semantic decisions. Use a cheap model only when its compact result replaces equivalent main-agent reading.
