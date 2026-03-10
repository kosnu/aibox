---
name: task
description: Unified task workflow for Codex. Auto-detects size (Small/Medium/Large) and follows the matching implementation flow. Use when the user says "/task" or asks to handle a task end-to-end.
argument-hint: "[issue-number or task description]"
---

# Task Workflow

## Step 1: Understand the Task

- If `$ARGUMENTS` is an issue number, inspect it with `gh issue view $ARGUMENTS`
- Identify scope, affected areas, and likely verification steps
- If repository instructions exist, follow them before implementation
- State the changed behavior or product rule in one sentence before planning
- Treat files named in the issue as entry points, not guaranteed full scope

## Step 1.5: Model The Changed Behavior

Before planning edits, identify where the changed behavior is represented in the codebase. Prefer a small set of categories, such as:

- UI
- schema or types
- mapping or API conversion
- tests or stories

Treat this as a synchronization checklist, not just an investigation note.

Start from the entry-point files, then search nearby files and imports with `rg`.

Stop expanding the search when:

- you have checked the likely representation categories for the changed behavior, or
- another search pass does not reveal a new adjacent representation

If a representation is intentionally unchanged, record why before implementation continues.

## Step 1.6: Preserve Uncertainty

Do not assume the discovered representations are complete.

Before editing, note where the current understanding may still be incomplete.

After editing, actively search for evidence that contradicts the new understanding of the behavior:

- old behavior still visible somewhere
- old assumptions still encoded in tests, types, mapping, copy, or UI
- sibling components or flows that still imply the previous rule

Treat completion as "no convincing contradiction found," not merely "the intended files were edited."

## Step 2: Size Detection

Detect size and state the reasoning to the user:

1. Changes span multiple distinct systems (for example FE + BE) -> **Large**
2. 4+ files or a complex feature in one system -> **Medium**
3. Otherwise -> **Small**

**Branch check:** If currently on `main` or `master`, recommend creating a work branch before implementation.

Then follow the matching workflow below.

---

## Small (1-3 files, simple fix)

1. **Investigate** - Read the target files and nearby tests directly
2. **Model & approve** - State the changed behavior and the representations that must stay in sync; get user approval before editing
3. **Implement** - Update the required representations directly
4. **Verify** - Run the smallest relevant checks for the touched area, then look for contradictions to the new behavior
5. **Done** - Summarize which representations were updated, which were checked but unchanged, and any follow-up command worth running

---

## Medium (4-10 files, single system)

1. **Investigate** - Explore related files first, prefer parallel reads/searches, and model the changed behavior across its representations
2. **Plan & approve** - Create a concrete implementation plan with files, synchronization points, and test strategy; get user approval
3. **Implement** - Execute the plan in sequence, updating the user as work progresses
4. **Review** - Review the resulting diff for regressions, edge cases, missing tests, unsynchronized representations, and evidence that the old behavior still exists elsewhere; fix critical issues before reporting back
5. **Verify** - Run relevant checks for the affected system
6. **Done** - Summarize outcome, verification, remaining risks, and the final synchronization status of each representation

Use these Codex tools when helpful:

- `update_plan` to track the implementation plan
- `multi_tool_use.parallel` for parallel reads/searches
- `exec_command` for repository inspection and verification
- `apply_patch` for manual file edits

---

## Large (10+ files, cross-system)

1. **Design** - Produce a fuller design and get user approval before editing
2. **Contract** - Define interfaces, sequencing, integration points between systems, and the representations that encode the changed behavior
3. **Plan** - Break the work into explicit stages with verification per stage and synchronization checkpoints
4. **Implement** - Work stage by stage, keeping integration points stable
5. **Review** - Review the full diff with emphasis on regressions across boundaries, partially updated representations, and contradictions that suggest the old behavior still exists
6. **Verify** - Run checks for all affected areas
7. **Done** - Summarize shipped scope, verification, unresolved risks, and the final synchronization status of the changed behavior

For large work, prefer `update_plan` and keep exactly one step `in_progress` at a time.

---

## Rules

- Never skip user approval on plans or designs
- No unrelated refactors or cleanup
- Keep tool usage specific and efficient
- Prefer concrete file-level plans over vague summaries
- Prefer behavior-level reasoning over file-level reasoning when the same rule may be represented in multiple places
- In the plan, name the representations being synchronized and avoid declaring the task complete until each one is updated or explicitly justified as unchanged
- In review, treat one-sided updates as a likely bug even when tests pass
- Assume there may be undiscovered representations of the changed behavior until contradiction search is complete
- Prefer searching for leftover evidence of the old behavior over searching only for support of the new behavior
- Scale the workflow up or down if the scope changes; tell the user when you do
