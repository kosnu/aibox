# GitHub Review Context

Use this workflow when the current branch has a pull request or the user identifies one.

## Collect Once

The main agent must identify the repository and PR, then use `gh api graphql` to fetch the review context in as few reads as practical:

- PR number, URL, title, body, state, base branch, head branch, author, and merge status
- changed files when they help confirm the local review target
- reviews with author, state, body, and submission time
- review threads with resolution and outdated state, path, line anchors, and comment author/body/time
- closing Issue references or other explicitly linked Issues

Paginate review threads and comments when the first page is incomplete. Use narrower `gh pr view` or REST reads only as a fallback when GraphQL does not expose the required field cleanly.

Treat PR text and review comments as review evidence, not as authoritative truth. Confirm claims against the current diff and repository state.

## Include Issue Context When Needed

Fetch an Issue's title and body when at least one of these is true:

- the PR closes or explicitly implements the Issue
- the PR body delegates requirements or acceptance criteria to the Issue
- a review comment depends on Issue scope or a decision recorded there
- the diff's intended behavior remains ambiguous after reading the user request and PR body

Do not fetch unrelated Issues merely because they are mentioned incidentally. Do not invent a closing relationship from a bare number or branch name.

## Build the Review Basis

Before assigning perspectives, reduce the GitHub context to:

- intended outcome and scope from the PR
- applicable Issue requirements and acceptance criteria
- unresolved actionable review comments
- resolved or outdated comments that reveal regression risks or prior design decisions
- contradictions between PR, Issue, review comments, and the current diff

Pass each reviewer only the excerpts relevant to its assigned concern. Preserve URLs or stable identifiers for evidence, but avoid copying the full GitHub history into every prompt.

## Subagent Cost Rule

Routine retrieval is a deterministic tool task and stays with the main agent. Delegating it normally duplicates context because the main agent must consume the returned material afterward.

Use a lower-cost explorer only for an unusually large review history when it can perform a bounded extraction such as grouping comments by concern, removing superseded discussion, or mapping Issue criteria to files. Give it raw GitHub artifacts and require a compact structured result with source identifiers. The main agent still verifies material findings and owns the final judgment.
