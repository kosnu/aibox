---
name: create-issue
description: Creates a GitHub issue using repository issue templates. Use when the user asks to create an issue or says "Issueを作って".
argument-hint: "[issue description]"
---

# Create Issue

## Step 1: Issue template detection

- Run `ls .github/ISSUE_TEMPLATE/` to get templates.
- If templates exist:
  - Read each template and infer use from `name:` and content.
  - Guess the best template from `$ARGUMENTS`.
  - Ask the user to confirm the template before creating the issue.
- If templates do not exist: continue without template.

## Step 2: Project selection

- Run `gh project list --limit 20`.
- If exactly one project exists: auto-select it and inform the user.
- If multiple projects exist: ask the user to choose one.
- If no project exists: create issue without project link.

## Step 3: Create the issue

- Fill title/body from selected template and `$ARGUMENTS`.
  - Exclude YAML frontmatter (`--- ... ---`) from the body.
  - Keep only the headings needed to make the issue understandable.
  - Prefer 2-3 short sections at most.
  - Summarize each section in 1-3 short bullet points or 1 short paragraph.
  - Do not leave blank placeholders.
- Without template, create a clear title/body from `$ARGUMENTS`.
  - Prefer a short title and a brief body with only the essential context, goal, and acceptance point.
- Before running `gh issue create`, show the user the exact draft title and body that will be used.
- Ask for explicit approval to create the issue after showing the draft.
- Run `gh issue create --title "..." --body "..." [--project "Project Name"]`.
- Show the created issue URL.

## Next Action

Suggest `/git-branch {issue-number}` after issue creation.

## Rules

- Always confirm guessed template with user before use.
- Always show the final draft issue title/body before creation.
- Never create the issue until the user approves the presented draft.
- If only one project exists, auto-selection is allowed.
- Never include template frontmatter in issue body.
- Prefer concise issue titles and bodies over template completeness.
- Omit template sections that do not add concrete information.
- Use non-interactive `gh issue create` with explicit `--title` and `--body`.
