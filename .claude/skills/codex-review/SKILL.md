---
name: codex-review
description: Review code using GitHub Copilot CLI with gpt-5.3-codex model.
argument-hint: "[file-path]"
disable-model-invocation: false
---

Use this skill when the user asks to review code via Copilot.

## Behavior
- If file argument provided: Review the specified file
- If no argument: Review current git changes (staged + unstaged)

## Your task

You are a senior software engineer performing a code review.

!`if [ -n "$ARGUMENTS" ]; then echo "Review the file: $ARGUMENTS"; else echo "Review the staged and unstaged git changes in the current directory."; fi`

Check for:
1. Bugs & correctness
2. Security vulnerabilities (injection, auth bypass, exposed secrets)
3. Performance issues (N+1 queries, memory leaks, unnecessary complexity)
4. Code quality (readability, naming, duplication)
5. Design & best practices (SOLID, error handling, patterns)

Format each issue as:
`[CRITICAL|WARN|INFO] <file>:<line> - <concise actionable description>`

Skip minor style nits. Be direct.
