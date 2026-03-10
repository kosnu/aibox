#!/usr/bin/env bash
set -euo pipefail

MODEL="${COPILOT_REVIEW_MODEL:-gpt-5.3-codex}"

if [ -n "${1:-}" ]; then
  CONTEXT="Review the file: $1"
else
  CONTEXT="Review the staged and unstaged git changes in the current directory."
fi

PROMPT="You are a senior software engineer performing a code review.
${CONTEXT}

Check for:
1. Bugs & correctness
2. Security vulnerabilities (injection, auth bypass, exposed secrets)
3. Performance issues (N+1 queries, memory leaks, unnecessary complexity)
4. Code quality (readability, naming, duplication)
5. Design & best practices (SOLID, error handling, patterns)

Format each issue as:
[CRITICAL|WARN|INFO] <file>:<line> - <concise actionable description>

Skip minor style nits. Be direct."

gh copilot \
  --prompt "$PROMPT" \
  --model "$MODEL" \
  --allow-tool 'shell(git)' \
  --allow-tool 'shell(cat)' \
  --allow-tool 'shell(ls)' \
  --allow-all-paths \
  --silent
