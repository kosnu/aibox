# Reviewer Contract

## Reviewer Model

For a bounded review, prefer an available lower-cost model with sufficient capability; use `gpt-6-luna` when it is offered by the current tool. Honor an explicit user model choice. Do not infer availability or pricing from a model name.

Use the actual delegation tool's schema. Request no inherited conversation (`fork_turns: "none"` for `collaboration.spawn_agent`; `fork_context: false` only for a tool that supports it). If model selection or isolated context is unsupported, keep that perspective with the main agent rather than inventing arguments or silently increasing cost.

Because reviewers receive no inherited context, make every assignment self-contained. Do not expect the reviewer to infer the target, requirements, repository state, or the meaning of a perspective from the conversation.

The main agent must always check:

- intended behavior or claims are supported by the review target
- the review target matches the requested scope
- prior comments are addressed or intentionally superseded
- linked Issue criteria are satisfied when applicable
- stale behavior does not remain elsewhere
- tests and synchronized representations match when applicable
- nearby repository patterns are followed
- edge cases and relevant performance, security, accessibility, and migration risks are covered

Prefer contradiction search. Look for evidence that old behavior or a missed representation remains.

## Reviewer Assignment

Give each reviewer one concrete, falsifiable question with narrow, non-overlapping ownership. Provide relevant excerpts instead of requiring reconstruction of a long conversation or GitHub history. Use this assignment shape, omitting fields that do not apply:

```text
Review question: <one falsifiable question>
Repository: <absolute path>
Target: <base/head, diff range, files, URLs, or sections>
Intended behavior and scope:
- <requirement or claim with source>
Perspective: <one named perspective>
Inspect specifically:
- <target-specific failure mode>
Applicable context:
- <rule/test/schema/config path or concise excerpt>
Known verification:
- <command and result, or "none">
Evidence required: <path_or_url + line_or_id for each material claim>
Exclude:
- edits, unrelated dirty changes, scope expansion, and <other reviewer ownership>
Allowed actions: <bounded read-only inspection and commands>
Return exactly: <result contract below>
Stop when: <question answered, evidence unavailable, or target/context ambiguous>
```

Require this compact result:

```text
question
findings[{severity, path_or_url, line_or_id, problem, impact, suggested_fix}]
evidence[{path_or_url, line_or_id, reason}]
unresolved[]
stop_reason
```

Allow at most one retry when a material finding lacks required evidence. The main agent verifies material evidence and does not ask another reviewer to repeat completed coverage.

Merge results into one judgment. Deduplicate findings, retain the clearest evidence, and record why a suggestion is rejected. If fixes were requested, fix only in-scope findings and rerun the relevant review. Stop for approval before any material scope or behavior change.
