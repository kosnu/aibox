# Reviewer Budget

Classify by risk and behavioral concerns, not raw file count. Record the classification and reason before choosing reviewers.

- **Small / Low risk:** one localized concern, established pattern, and no high-risk domain. Use main-agent checklist review only.
- **Small / Normal risk:** localized change with a meaningful edge case, stale assumption, or test gap risk. Use at most 1 reviewer subagent.
- **Medium:** two or three concerns that can drift, or one moderately complex behavior change. Use 1-2 non-overlapping reviewers.
- **Large / High risk:** four or more concerns, cross-system contracts, auth, permissions, security, payments, migrations, irreversible data changes, scale-sensitive paths, or broad user-visible flows. Use 2 or more reviewers with explicit ownership.

Use fewer subagents when concerns are tightly coupled. Use more only when each perspective can find a distinct class of failure.
