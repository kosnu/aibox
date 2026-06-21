# Approval Gate

Stop after presenting the plan.

## Before Approval

Do not:

- edit files
- apply patches
- run write operations
- run formatters that rewrite files
- implement part of the plan

## Approval Requirements

The approval-ready response must include:

- the changed behavior
- synchronized representations
- in-scope and out-of-scope boundaries
- acceptance criteria
- verification strategy
- explicit uncertainties and contradiction-search targets
- investigation and review subagent budget
- a compact implementation plan

## Stop Conditions

Stop and request missing input only when:

- behavior or acceptance criteria cannot be inferred after grounding
- implementation choices change user-visible behavior, risk, or cost
- write scope expands materially beyond the requested task

Never skip user approval before implementation.
