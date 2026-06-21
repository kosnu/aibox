# Review

Review the implemented diff before final verification. Review is mandatory.

## Required Review Areas

Check:

- regressions and edge cases
- missing or stale tests
- unsynchronized representations
- evidence that old behavior still exists elsewhere
- contradictions to the current understanding of the changed behavior
- repository pattern drift and unstated convention violations

The main agent must perform a checklist review for every task, including Small work.

## Review Budget

- **Small / Low risk:** main agent checklist review only; record it as local review.
- **Small / Normal risk:** at most 1 reviewer subagent focused on regressions, stale assumptions, missing tests, or missing representations.
- **Medium:** 1 reviewer plus main agent checklist review is usually enough when concerns are coupled; use 2 only for distinct ownership areas.
- **Large / High risk:** 2 or more reviewers with distinct ownership for behavior, tests, data, UX, performance, rollout, or other relevant risks.

When subagents are used, assign distinct review ownership. When no subagent is used, briefly record the main-agent checklist findings so review is visible rather than implied.
