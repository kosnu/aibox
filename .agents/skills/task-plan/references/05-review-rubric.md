# Review Rubric

Review the plan before presenting it for approval.

## Required Evaluation Areas

Evaluate:

- maintainability
- testability
- ease of future changes
- UX impact
- performance impact
- missing representations
- stale assumptions or contradiction-search gaps

The main agent owns every area unless a subagent reviewer is assigned.

## Reviewer Assignment

Assign reviewer focus by task shape:

- backend-heavy work: senior engineer owns maintainability, testability, and data/API risk
- UX-heavy work: senior designer owns user flow and interaction risk
- scope, sequencing, rollout, or prioritization tradeoffs: senior product manager owns product risk
- performance-sensitive work: senior engineer or performance-focused reviewer owns performance risk

Before subagent review, make sure every required evaluation area has an owner.

## Review Questions

Look for:

- over-complicated sequencing or architecture
- weak module boundaries or unclear ownership
- plans that are hard to test or verify safely
- ignored user flows or UX tradeoffs
- hidden performance regressions or scale risks
- missing representations, stale assumptions, or contradiction-search gaps

## After Review

- Revise the plan when findings expose a meaningful weakness.
- If a suggestion is not adopted, keep the reason concise.
- Present the revised plan, not the pre-review draft.
- List meaningful unresolved reviewer concerns as approval risks.
- Include only review findings that affected the plan or remain relevant to approval.
