# GitHub Review Threads

Resolve the PR from an explicit URL or number, or from the current branch with `gh pr view --json number,url,headRepository,headRepositoryOwner`.

Use `gh api graphql` to fetch `reviewThreads` with `id`, `isResolved`, `isOutdated`, path and line anchors, and comment `databaseId`, body, author, URL, time, and `replyTo`. Paginate with `endCursor` while `hasNextPage` is true.

Reply to the thread ID with:

```bash
gh api graphql \
  -F threadId=THREAD_ID \
  -F body='REPLY_BODY' \
  -f query='mutation($threadId: ID!, $body: String!) { addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $threadId, body: $body}) { comment { url } } }'
```

Resolve a completed thread with:

```bash
gh api graphql \
  -F threadId=THREAD_ID \
  -f query='mutation($threadId: ID!) { resolveReviewThread(input: {threadId: $threadId}) { thread { isResolved } } }'
```

Use the thread-scoped mutations as the normal path. Do not switch to comment-ID reply endpoints or announce transport fallback. Verify posted replies and resolution state after each write.
