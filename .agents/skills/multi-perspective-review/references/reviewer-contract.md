# Reviewer Contract

The main agent must always check:

- intended behavior is implemented
- the diff matches PR scope
- prior comments are addressed or intentionally superseded
- linked Issue criteria are satisfied when applicable
- stale behavior does not remain elsewhere
- tests and synchronized representations match
- nearby repository patterns are followed
- edge cases and relevant performance, security, accessibility, and migration risks are covered

Prefer contradiction search. Look for evidence that old behavior or a missed representation remains.

For each reviewer, provide the exact target, relevant PR/Issue/comment context, one perspective, expected findings-first format, and instructions not to edit or inspect unrelated dirty changes. Keep assignments narrow and non-overlapping.

Merge results into one judgment. Deduplicate findings, retain the clearest evidence, and record why a suggestion is rejected. If fixes were requested, fix only in-scope findings and rerun the relevant review. Stop for approval before any material scope or behavior change.
