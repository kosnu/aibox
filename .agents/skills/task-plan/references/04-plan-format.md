# Plan Format

Produce a compact, decision-complete plan.

## Required Content

Include:

1. **Changed behavior:** one sentence stating the product rule or behavior change.
2. **Size:** Small, Medium, or Large with concern-based reasoning.
3. **Representations:** synchronized representations and intentionally unchanged representations.
4. **Scope:** expected files, modules, or areas to touch, plus explicit out-of-scope work.
5. **Acceptance criteria:** what must be true when implementation is complete.
6. **Verification:** checks, tests, stories, or manual validation expected.
7. **Risks:** uncertainties, contradiction-search targets, guardrails, and rollback notes when relevant.
8. **Approval:** expected subagent budget during execution/review, then stop before edits.

## Medium And Large Work

Also include:

- parts that can be implemented independently
- likely candidates for subagent execution later
- ownership boundaries or write scopes that allow safe parallel work

## Presentation Rules

- Keep the plan decision-complete but compact.
- Do not include raw research transcript.
- Do not include long reviewer dialogue.
- Do not list every inspected file unless it changes scope, risk, verification, or ownership.
- Prefer behavior-level reasoning over file-level reasoning when one rule is represented in multiple places.
