---
name: task-plan
description: Investigate a repository task, model the changed behavior, apply size/risk-based subagent budgets for investigation and review, and produce an approval-ready implementation plan. Use when the user says "$task-plan" or asks to plan work before editing.
argument-hint: "[issue-number or task description]"
---

# Task Planning Workflow

## Goal

Produce an approval-ready plan before any edits.

State the changed behavior or product rule in one sentence, identify the representations that must stay in sync, and stop after the user approves the plan.

Repository rules, local patterns, and unstated conventions must still be investigated. Do not save rate limit by skipping grounding or review. Save rate limit by limiting subagent count according to the size/risk budget below while the main agent owns critical-path investigation and final judgment.

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

Detect size by the number and risk of behavioral representation concerns that must stay synchronized, not by the raw number of files changed.

A representation concern is a behavioral surface or rule that can drift from the others if it is not updated with the same change. Common concerns include:

- UI or UX behavior
- state management
- validation
- API request/response mapping
- schema, migration, or database constraint
- domain types
- auth, permissions, payments, or other high-risk rules
- error handling
- routing
- tests, stories, fixtures, or mocks
- performance, accessibility, rollout, or backward compatibility

Classify the work and state the reasoning to the user:

1. 4 or more distinct concerns, cross-system contract changes, or high-risk domains such as auth, permissions, payments, database migrations, or irreversible data changes -> **Large**
2. 2-3 distinct concerns, or a moderately complex behavior change within one system where synchronization can drift -> **Medium**
3. 1 primary concern, even when reflected mechanically across multiple files using an established pattern -> **Small**

The raw number of files is only a warning signal. Many files can still be Small when they repeat one established change pattern. Few files can still be Medium or Large when they combine multiple concerns or high-risk behavior.

**Branch check:** If currently on `main` or `master`, recommend creating a work branch before implementation.

## Step 3: Budgeted Investigation And Design

Use the smallest investigation budget that still protects repository rules, local patterns, and unstated conventions.

The main agent must start by checking the immediate blocking context:

- repository instructions such as `AGENTS.md` or `CLAUDE.md`
- named files, issue references, or explicit entry points
- nearby imports, sibling implementations, and established local patterns
- relevant tests, stories, fixtures, mocks, or verification commands
- contradiction-search targets from Step 1.6

After the main-agent grounding pass, identify whether there is a concrete independent sidecar question. Use subagents only when the question is independent enough to answer without blocking the main agent and the size/risk budget allows it.

Subagent investigation budget:

- **Small / Low risk:** main-agent investigation only by default. Use at most 1 `explorer` only if a concrete independent risk or question is named.
- **Small / Normal risk:** main-agent investigation remains primary. Use at most 1 `explorer` for a clearly independent uncertainty.
- **Medium:** main agent plus, when useful, 1 `explorer`. Add more only when concerns are independent and the extra agent has a distinct ownership area.
- **Large / High risk:** multiple subagents are allowed when each has an explicit role, ownership boundary, and question to answer.

If no subagent is used, do not merely say the work was small or coupled. Briefly record the main-agent checks that covered repository rules, local patterns, relevant tests, and contradiction targets.

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
- the subagent budget expected during execution and review

For Medium and Large work, also include:

- which parts can be implemented independently
- which parts are likely candidates for subagent execution later
- the ownership boundaries or write scopes that would let workers operate safely in parallel

## Step 5: Review The Plan Within Budget

Before presenting the plan for approval, review the plan. Review is mandatory; subagent-based review is budgeted.

The plan review must explicitly evaluate:

- maintainability
- testability
- ease of future changes
- UX impact
- performance impact
- missing representations
- stale assumptions or contradiction-search gaps

Main agent checklist review is required for every task, including Small work. The main agent must check the evaluation areas above before asking for approval.

Subagent review budget:

- **Small / Low risk:** main agent checklist review only. Do not call this skipped review; record it as local review.
- **Small / Normal risk:** at most 1 reviewer subagent. Focus the reviewer on repository pattern drift, stale assumptions, or missing representations.
- **Medium:** 2 reviewers by default. If the concerns are tightly coupled and clearly covered, 1 reviewer plus main agent checklist review is acceptable.
- **Large / High risk:** 2 or more reviewers. Assign coverage for UX, performance, data, rollout, or other relevant risk areas.

Pick the reviewer mix based on the task shape. For example:

- backend-heavy work: senior engineer owns maintainability, testability, and data/API risk
- UX-heavy work: senior designer owns user flow and interaction risk
- scope, sequencing, rollout, or prioritization tradeoffs: senior product manager is mandatory
- performance-sensitive work: assign a reviewer who explicitly owns performance concerns, usually the senior engineer unless another reviewer is better suited

Before starting subagent review, assign the required evaluation areas to specific reviewers and make sure every area has a named owner. When the budget uses no subagent, the main agent owns all evaluation areas and must state that explicitly.

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
- Never skip plan review before requesting approval
- No unrelated refactors or cleanup
- Keep tool usage specific and efficient
- Do not classify by the raw number of files alone
- For Small work, do not spend subagents unless a concrete independent risk or question is named
- Prefer behavior-level reasoning over file-level reasoning when the same rule may be represented in multiple places
- Prefer concrete file-level plans over vague summaries
- In the plan, name the representations being synchronized and avoid calling the task ready until each one is covered or explicitly justified as unchanged
- Assume there may be undiscovered representations until contradiction search is complete
- Prefer searching for leftover evidence of the old behavior over searching only for support of the new behavior
- Scale the workflow up or down if the scope changes; tell the user when you do
