# Implementation

Execute the approved plan while keeping representations synchronized.

## Rules

- Update required representations directly.
- Keep user updates concise and factual.
- Keep edits scoped to the approved task.
- Do not silently re-plan inside execution.
- If the approved plan proves materially incomplete, stop at the re-approval gate.

## Synchronization

Treat one-sided updates as likely bugs even when tests pass.

While implementing, keep in sync:

- user-visible behavior
- types, schemas, mappings, or API boundaries
- tests, fixtures, stories, and mocks
- docs or policy files included in approved scope
- verification commands and expectations

For minor clarifications that do not change approved scope or behavior, proceed and note the clarification in the final summary.
