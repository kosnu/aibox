# Reviewer Budget

Choose coverage by risk and behavioral concerns, not raw file count. These budgets are starting points, not required agent counts.

- **Small / Low risk:** one localized concern, established pattern, and no high-risk domain. Use main-agent checklist review only.
- **Small / Normal risk:** localized change with a meaningful edge case, stale assumption, or test gap risk. Use at most 1 reviewer subagent.
- **Medium:** two or three concerns that can drift, or one moderately complex behavior change. Consider 1-2 non-overlapping reviewers.
- **Large / High risk:** cross-system contracts, auth, permissions, security, payments, migrations, irreversible data changes, or broad user-visible flows. Prioritize independent checks of the material risks; use multiple reviewers only for separable questions.

Keep tightly coupled concerns with the main agent. Delegate only when tools and authorization allow it and independent evidence is worth the extra context and coordination. If delegation is unavailable, cover the perspectives directly and disclose any remaining coverage gap.
