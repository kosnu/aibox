---
name: task-plan
description: Investigate a repository task, model the changed behavior, parallelize research/design with subagents, review the plan with senior-role subagents, and produce an approval-ready implementation plan. Use when the user says "$task-plan" or asks to plan work before editing.
argument-hint: "[issue-number or task description]"
---

# Task Planning Workflow

## Goal

Produce an approval-ready plan before any edits.

State the changed behavior or product rule in one sentence, identify the representations that must stay in sync, and stop after the user approves the plan.

## Step 1: Understand the Task

- If `$ARGUMENTS` is an issue number, inspect it with `gh issue view $ARGUMENTS`
- Identify scope, affected areas, likely verification steps, and likely integration boundaries
- If repository instructions exist, follow them before planning
- Treat files named in the issue as entry points, not guaranteed full scope

## Step 1.5: Model The Changed Behavior

Before planning edits, identify where the changed behavior is represented in the codebase. Prefer a small set of categories, such as:

- UI
- schema or types
- mapping or API conversion
- tests or stories
- integration or orchestration

Treat this as a synchronization checklist, not just an investigation note.

Start from the entry-point files, then search nearby files and imports with `rg`.

Stop expanding the search when:

- you have checked the likely representation categories for the changed behavior, or
- another search pass does not reveal a new adjacent representation

If a representation is intentionally unchanged, record why before approval is requested.

## Step 1.6: Preserve Uncertainty

Do not assume the discovered representations are complete.

Before finishing the plan, note where the current understanding may still be incomplete.

Actively search for evidence that contradicts the current understanding:

- old behavior still visible somewhere
- old assumptions still encoded in tests, types, mapping, copy, or UI
- sibling components or flows that still imply the previous rule

Treat planning as complete only when no convincing contradiction remains undiscovered enough to block implementation.

## Step 2: Size Detection

Detect size and state the reasoning to the user:

1. Changes span multiple distinct systems (for example FE + BE) -> **Large**
2. 4+ files or a complex feature in one system -> **Medium**
3. Otherwise -> **Small**

**Branch check:** If currently on `main` or `master`, recommend creating a work branch before implementation.

## Step 3: Parallel Investigation And Design

Use subagents to accelerate research and design.

- Start with the main agent doing the immediate blocking read needed to frame the task
- Then identify independent investigation or design questions that can run in parallel
- Spawn subagents for those sidecar questions instead of doing all exploration sequentially
- Prefer `explorer` subagents for codebase investigation and design validation
- Reuse existing subagents for related follow-up questions when practical
- While subagents run, continue non-overlapping local investigation instead of waiting idly

For Medium and Large work, parallel subagent-based investigation is the default. For Small work, still use subagents when there are at least two independent questions or representations to inspect.

If subagents are not used, explicitly state why the work was too small or too coupled to parallelize safely.

## Step 4: Build The Plan

Produce a concrete implementation plan that includes:

- the changed behavior in one sentence
- the size classification with reasoning
- the representations being synchronized
- entry-point files and other expected files to touch
- files or representations checked and intentionally left unchanged
- acceptance criteria
- verification strategy
- rollback or guardrail notes when the change is risky
- explicit uncertainties and contradiction-search targets
- reviewer-assigned concerns for execution, if already known

For Medium and Large work, also include:

- which parts can be implemented independently
- which parts are likely candidates for subagent execution later
- the ownership boundaries or write scopes that would let workers operate safely in parallel

## Step 5: Review The Plan

Before presenting the plan for approval, review the plan with subagents.

This review is mandatory regardless of task size.

Use subagents that emulate senior perspectives appropriate to the task, such as:

- senior engineer
- senior designer
- senior product manager

Use at least two reviewer subagents whenever multiple perspectives are relevant.

Senior engineer review is mandatory for every task so maintainability, testability, and ease of future changes always have an explicit owner.

Pick the reviewer mix based on the task shape. For example:

- backend-heavy work: senior engineer is mandatory
- UX-heavy work: senior designer is mandatory
- scope, sequencing, rollout, or prioritization tradeoffs: senior product manager is mandatory
- performance-sensitive work: assign a reviewer who explicitly owns performance concerns, usually the senior engineer unless another reviewer is better suited

Run these reviews in parallel when there are multiple relevant perspectives.

The plan review must explicitly evaluate:

- maintainability
- testability
- ease of future changes
- UX
- performance

Before starting review, assign the required evaluation areas to specific reviewers and make sure every area has a named owner.

Ask reviewers to look for:

- over-complicated sequencing or architecture
- weak module boundaries or unclear ownership
- plans that are hard to test or verify safely
- user flows or UX tradeoffs that the implementation plan ignores
- performance regressions or scale risks hidden by the proposed approach
- missing representations, stale assumptions, or contradiction-search gaps

After the review:

- summarize the key findings from each reviewer perspective
- revise the plan before presenting it if the findings expose a meaningful weakness
- if you decide not to adopt a reviewer suggestion, explain why
- present the revised plan, not the pre-review draft
- if meaningful reviewer concerns remain unresolved, list them explicitly as approval risks

Do not present the plan as approval-ready until this review pass is complete.

## Step 6: Approval Gate

Stop after presenting the plan and get user approval before editing any files.

Do not implement, patch files, or run write operations during this skill.

## Rules

- Never skip user approval before implementation
- Never skip subagent-based plan review before requesting approval
- No unrelated refactors or cleanup
- Keep tool usage specific and efficient
- Prefer behavior-level reasoning over file-level reasoning when the same rule may be represented in multiple places
- Prefer concrete file-level plans over vague summaries
- In the plan, name the representations being synchronized and avoid calling the task ready until each one is covered or explicitly justified as unchanged
- Assume there may be undiscovered representations until contradiction search is complete
- Prefer searching for leftover evidence of the old behavior over searching only for support of the new behavior
- Scale the workflow up or down if the scope changes; tell the user when you do
