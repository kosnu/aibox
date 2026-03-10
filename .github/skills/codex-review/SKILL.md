---
name: codex-review
description: Review code using GitHub Copilot CLI with gpt-5.3-codex model.
argument-hint: "[file-path]"
disable-model-invocation: false
---

Use this skill when the user asks to review code via Copilot.

## Commands
- `/codex-review` — Review current git changes (staged + unstaged)
- `/codex-review <file>` — Review a specific file

## Implementation
Run:
```bash
.github/skills/codex-review/scripts/codex_review.sh $ARGUMENTS
```

## Notes
- Requires `gh` with Copilot extension installed.
- Default model: `gpt-5.3-codex` (override with `COPILOT_REVIEW_MODEL` env var).
- Prompt is English-only to minimize token usage.
- Output format: `[SEVERITY] file:line - description`
