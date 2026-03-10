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
  - Keep all section headings from the template.
  - Do not leave blank placeholders.
- Without template, create a clear title/body from `$ARGUMENTS`.
- Run `gh issue create --title "..." --body "..." [--project "Project Name"]`.
- Show the created issue URL.

## Next Action

Suggest `/git-branch {issue-number}` after issue creation.

## Rules

- Always confirm guessed template with user before use.
- If only one project exists, auto-selection is allowed.
- Never include template frontmatter in issue body.
- Use non-interactive `gh issue create` with explicit `--title` and `--body`.
