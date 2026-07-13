---
name: reply-review-comments
description: Reply to recently addressed GitHub PR review comments from the current branch, explain how each comment was handled, include commit IDs when relevant, and resolve only threads that are fully complete. Use when the user asks to reply to handled review comments or resolve completed review threads.
---

# Reply Review Comments

Reply in Japanese to recently handled PR review comments and resolve only fully completed threads.

## Preconditions

- Replies and thread resolution write to GitHub. Perform those writes only when the user's request includes replying or resolving.
- If the target PR is not specified, prefer the PR associated with the current branch.
- Target only review comments that were recently addressed. Do not reply to a thread when the handling is ambiguous.

## Stop Rules

Stop before posting replies or resolving threads when:

- the target PR cannot be resolved
- thread-level review data cannot be fetched reliably
- the handling is ambiguous or cannot be tied to the current branch, recent commits, or implementation state
- resolving the thread would hide unresolved follow-up work or conflicting feedback

## Workflow

1. Resolve the target PR.
2. Read [references/github-threads.md](references/github-threads.md), then fetch all relevant review threads with their resolution and outdated state.
3. Match unresolved, non-outdated comments to the current diff, recent commits, or implementation evidence. Touching the same file is not proof of completion.
4. Read [references/reply-quality.md](references/reply-quality.md), then draft one concrete reply per clearly handled thread.
5. Post replies through the thread-scoped GraphQL mutation. Use a top-level PR comment only for feedback that has no replyable thread.
6. Resolve only threads that satisfy every completion condition in `reply-quality.md`.
7. Report replied, resolved, and skipped threads separately with brief reasons.
