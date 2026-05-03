---
name: reply-review-comments
description: Reply to recently addressed GitHub PR review comments from the current branch, explain how each comment was handled, include commit IDs when relevant, and resolve only threads that are fully complete. Use when the user asks to reply to handled review comments or resolve completed review threads.
---

# Reply Review Comments

Use this skill when PR review comments have already been handled through code changes or explanation, and the user wants Codex to reply to those comments and resolve fully completed threads.

## When To Use

- The user asks Codex to reply to recently handled review comments.
- Each reply needs to explain what changed or how the comment was addressed.
- Relevant commit IDs should be included when the handling is already committed.
- Only fully completed threads should be resolved.

## Preconditions

- Replies and thread resolution write to GitHub. Perform those writes only when the user's request includes replying or resolving.
- If the target PR is not specified, prefer the PR associated with the current branch.
- Target only review comments that were recently addressed. Do not reply to a thread when the handling is ambiguous.

## Workflow

1. Resolve the target PR.
   - Use the PR URL, `owner/repo` plus PR number, or the PR associated with the current branch.
2. Fetch review threads.
   - Use `gh pr view --json number,url,headRepository,headRepositoryOwner` when the PR should come from the current branch.
   - Use `gh api graphql` directly to inspect `reviewThreads`, including `id`, `isResolved`, `isOutdated`, path and line anchors, and each comment's `databaseId`, `body`, `author`, and `replyTo`.
   - If the first page has `hasNextPage: true`, repeat the query with the returned `endCursor` until all relevant threads are fetched.
3. Narrow the target set to recently handled threads.
   - Prefer unresolved, non-outdated threads.
   - Reply only when the requested change is clearly satisfied by the current branch diff, recent commits, or implementation state.
   - Do not treat touching the same file as sufficient proof that the requested change was handled.
4. Draft one reply per thread.
   - Explain what changed or how the comment was handled in 1-3 concrete sentences.
   - Include a commit ID only when the change is committed and the commit-to-comment mapping is clear.
   - Do not wrap commit IDs in backticks.
   - Put one ASCII space before and after each commit ID.
   - Example: `Handled in commit  abc1234  and updated the validation path accordingly.`
   - If the change is not committed, do not invent a commit ID. Say that the change is not committed if that matters.
5. Post the replies.
   - For inline review threads, use the `addPullRequestReviewThreadReply` GraphQL mutation through `gh api graphql`.
   - Reply to the target thread ID from `reviewThreads.nodes.id`; do not post through comment-ID reply endpoints.
   - Do not announce endpoint fallback or transport switching. The normal path is the thread-scoped GraphQL mutation.
   - If the feedback exists only in a review summary with no replyable thread, add a top-level PR comment only when that is the right place to follow up.
6. Resolve only fully completed threads.
   - After replying, use the `resolveReviewThread` GraphQL mutation through `gh api graphql`.
   - Resolve only when all of these are true:
     - The requested issue is actually fixed on the current branch.
     - No follow-up work or confirmation is pending.
     - The reply is consistent with the implementation.
     - There are no conflicting comments or unresolved concerns.

## Resolve Mutation

```bash
gh api graphql \
  -F threadId=THREAD_ID \
  -f query='mutation($threadId: ID!) { resolveReviewThread(input: {threadId: $threadId}) { thread { isResolved } } }'
```

## Reply Mutation

```bash
gh api graphql \
  -F threadId=THREAD_ID \
  -F body='REPLY_BODY' \
  -f query='mutation($threadId: ID!, $body: String!) { addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) { comment { url } } }'
```

## Review Thread Query

Use this query through `gh api graphql` when thread-aware data is needed:

```bash
gh api graphql \
  -F owner=OWNER \
  -F repo=REPO \
  -F number=PR_NUMBER \
  -f query='
query($owner: String!, $repo: String!, $number: Int!, $cursor: String) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewThreads(first: 100, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          isResolved
          isOutdated
          path
          line
          startLine
          originalLine
          originalStartLine
          comments(first: 100) {
            nodes {
              id
              databaseId
              body
              createdAt
              updatedAt
              url
              author { login }
              replyTo { databaseId }
            }
          }
        }
      }
    }
  }
}'
```

## Reply Quality Bar

- Do not reply with only "fixed" or "addressed"; summarize the concrete handling.
- Mention file names or function names only when they help the reviewer understand the response.
- If explanation alone addressed the comment, do not invent a code change.
- Do not resolve partially handled threads.
- Briefly report back to the user which threads were replied to and which threads were resolved.
