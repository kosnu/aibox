# Re-approval Gate

Do not continue on an implicitly rewritten plan.

Stop and request re-approval when:

- approved behavior or acceptance criteria would change
- write scope expands materially beyond the approved plan
- size/risk classification changes
- UX direction changes in a user-visible way
- performance characteristics or risk profile changes materially
- rollout sequence or verification strategy changes materially
- the approved plan is missing a representation that must change to keep behavior synchronized

Do not turn these stops into a new approval-ready plan inside `$task-execute`. Report the gap and wait for the user to re-plan or approve the scope change.

Minor clarifications do not require re-approval:

- choosing between two already-in-scope helper functions
- confirming the exact existing test file to extend
- adjusting local implementation order without changing behavior, scope, or verification strategy
