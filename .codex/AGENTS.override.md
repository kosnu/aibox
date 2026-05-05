Respond to the user in Japanese.

When writing PR comments, do not wrap commit IDs in backticks.

## Outcome-First Work

- Prefer concise, outcome-first instructions over long process stacks.
- For non-trivial or side-effectful repository work, clarify the goal, scope, constraints, success criteria, verification, and stop conditions before acting.
- Keep explanations as explanations. Do not turn an explanation, investigation, feasibility check, comparison, or recommendation request into an implementation plan unless the user asks for a plan.
- When a task has an approved plan, execute that plan directly. Do not recreate a new approval-ready plan unless scope, behavior, risk, or verification changes materially.
- For side-effectful GitHub or git actions, stop before writing if the target, scope, approval, or safety condition is ambiguous.

## Scope and Constraints

- Solve only the requested issue with the smallest practical diff.
- Treat user constraints exactly as stated. Do not reinterpret, broaden, or weaken them.
- Do not introduce new state, helpers, abstractions, or shared layers unless they are required for the requested change.
