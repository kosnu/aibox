# Reviewer Contract

## Reviewer Model

Run reviewer subagents with `model: gpt-5.6-luna` and `fork_context: false`. Do not inherit the main agent's model or full conversation history.

If `gpt-5.6-luna` is unavailable, use the lowest-cost available model that can perform the bounded review. Do not silently fall back to the main agent's model. When no explicit lower-cost model is available, keep that perspective with the main agent instead of spawning a reviewer.

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

Give each reviewer one concrete, falsifiable review question. Include all of the following in the assignment:

- exact repository and review target: absolute working directory, base/head or diff range, and owned files, URLs, or document sections
- intended behavior and scope: relevant user request, approved plan, PR claims, Issue acceptance criteria, and unresolved comment excerpts
- one named perspective with a target-specific checklist of failure modes to inspect
- applicable repository rules and the exact paths to supporting tests, fixtures, schemas, configs, or docs
- known verification results and claims that still require independent confirmation
- evidence requirements: cite a path or URL plus line or stable identifier for every material finding
- explicit exclusions: no edits, no unrelated dirty changes, no scope expansion, and no review concerns owned by another reviewer
- allowed read-only inspection or commands, the required result shape, and a stop condition for missing access or ambiguous evidence

Keep assignments narrow and non-overlapping. Prefer concrete checks such as "verify every renamed field is updated in schema, parser, fixture, and test" over broad prompts such as "review for quality." Provide relevant excerpts when the reviewer would otherwise have to reconstruct intent from a long conversation or GitHub history.

Use this assignment shape:

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
